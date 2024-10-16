//
//  ExpenseManager.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseFunctions
import FirebaseStorage

class ExpenseManager {
    static let shared = ExpenseManager()
    private let expensesCollection = Firestore.firestore().collection("expenses")
    
    private init() {}
    
    func getExpense(id: String) async throws -> Expense {
        try await expensesCollection.document(id).getDocument(as: Expense.self)
    }
    
    func getAllExpensesByUser() async throws -> [Expense] {
        do {
            let userId = KeychainManager.get(account: "account")
            let documentId = String(decoding: userId ?? Data(), as: UTF8.self)
            let expenses: [Expense] = try await expensesCollection
                .whereField("userId", isEqualTo: documentId)
                .getDocuments(as: Expense.self)
            return expenses
        } catch {
            throw SBError.invalidResponse
        }
    }
    
    func getAllExpensesByUserByDate(date: String) async throws -> [Expense] {
        do {
            let userId = KeychainManager.get(account: "account")
            let documentId = String(decoding: userId ?? Data(), as: UTF8.self)
            
            let expenses: [Expense] = try await expensesCollection
                .whereField("userId", isEqualTo: documentId)
                .whereField("dateTime", isEqualTo: date)
                .getDocuments(as: Expense.self)
            return expenses
        } catch {
            throw SBError.invalidResponse
        }
    }
    
    func saveExpense(categoryFieldName: String, category: Category, price: Int, note: String?, date: Date, repeatInterval: RepeatInterval?) async throws {
        guard let userId = fetchUserId() else { throw SBError.invalidResponse }
        let db = Firestore.firestore()
        let collection = db.collection("expenses")
        
        if let repeatInterval = repeatInterval, repeatInterval != .never {
            try await saveRepeatingExpenses(categoryFieldName: categoryFieldName, category: category, price: price, note: note, baseDate: date, repeatInterval: repeatInterval, collection: collection, userId: userId)
        } else {
            try await saveSingleExpense(categoryFieldName: categoryFieldName, category: category, price: price, note: note, date: date, collection: collection, userId: userId)
        }
    }
    
    private func fetchUserId() -> String? {
        guard let userIdData = KeychainManager.get(account: "account") else { return nil }
        return String(decoding: userIdData, as: UTF8.self)
    }
    
    private func saveRepeatingExpenses(categoryFieldName: String, category: Category, price: Int, note: String?, baseDate: Date, repeatInterval: RepeatInterval, collection: CollectionReference, userId: String) async throws {
        let calendar = Calendar.current
        var currentDate = baseDate
        
        for _ in 0..<12 {
            switch repeatInterval {
            case .daily:
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
                let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!
                let daysInMonth = calendar.dateComponents([.day], from: monthStart, to: monthEnd).day! + 1
                
                let remainingDays = calendar.dateComponents([.day], from: max(currentDate, monthStart), to: monthEnd).day! + 1
                let totalMonthlyPrice = price * remainingDays
                
                try await saveSingleExpense(categoryFieldName: categoryFieldName, category: category, price: totalMonthlyPrice, note: note, date: max(currentDate, monthStart), collection: collection, userId: userId)
                
                currentDate = calendar.date(byAdding: .month, value: 1, to: monthStart)!
                
            case .weekly:
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
                let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!
                
                let remainingWeeks = ceil(Double(calendar.dateComponents([.day], from: max(currentDate, monthStart), to: monthEnd).day! + 1) / 7.0)
                let totalMonthlyPrice = Int(Double(price) * remainingWeeks)
                
                try await saveSingleExpense(categoryFieldName: categoryFieldName, category: category, price: totalMonthlyPrice, note: note, date: max(currentDate, monthStart), collection: collection, userId: userId)
                
                currentDate = calendar.date(byAdding: .month, value: 1, to: monthStart)!
                
            case .monthly:
                try await saveSingleExpense(categoryFieldName: categoryFieldName, category: category, price: price, note: note, date: currentDate, collection: collection, userId: userId)
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                
            case .yearly:
                if calendar.component(.month, from: currentDate) == calendar.component(.month, from: baseDate) {
                    try await saveSingleExpense(categoryFieldName: categoryFieldName, category: category, price: price, note: note, date: currentDate, collection: collection, userId: userId)
                } else {
                    try await saveSingleExpense(categoryFieldName: categoryFieldName, category: category, price: 0, note: note, date: currentDate, collection: collection, userId: userId)
                }
                currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                
            case .never:
                break
            }
        }
    }
    
    private func saveSingleExpense(categoryFieldName: String, category: Category, price: Int, note: String?, date: Date, collection: CollectionReference, userId: String) async throws {
        let formattedDate = date.formatToMonthYear()
        
        if let existingExpense = try await checkIfUserExpenseExists(userId: userId, categoryFieldName: categoryFieldName, category: category, date: date) {
            let updatedPrice = existingExpense.price + price
            let updatedNote = combineNotes(existing: existingExpense.note, new: note)
            
            try await updateExpense(id: existingExpense.id, price: updatedPrice, note: updatedNote, date: date)
        } else {
            let id = UUID().uuidString
            let expense = Expense(id: id, categoryFieldName: categoryFieldName, category: category, price: price, note: note, userId: userId, dateTime: formattedDate, repeatInterval: .never)
            try await saveExpenseToFirestore(expense: expense, collection: collection)
        }
    }
    
    private func combineNotes(existing: String?, new: String?) -> String? {
        switch (existing, new) {
        case (nil, nil):
            return nil
        case (let existing?, nil):
            return existing
        case (nil, let new?):
            return new
        case (let existing?, let new?):
            return "\(existing), \(new)"
        }
    }
    
    private func saveExpenseToFirestore(expense: Expense, collection: CollectionReference) async throws {
        do {
            let encodedExpense = try Firestore.Encoder().encode(expense)
            try await collection.document(expense.id).setData(encodedExpense)
        } catch {
            throw SBError.serializationError
        }
    }
    
    func updateExpense(id: String, price: Int, note: String?, date: Date?) async throws {
        let expenseQuery = expensesCollection.whereField("id", isEqualTo: id)
        let expenseSnapshot = try await expenseQuery.getDocuments()
        
        guard let expenseDocument = expenseSnapshot.documents.first else {
            throw SBError.invalidResponse
        }
        
        var updateData: [String: Any] = [:]
        updateData["price"] = price
        if let note = note {
            updateData["note"] = note
        }
        
        if let date = date {
            updateData["dateTime"] = date
        }
    
        try await expenseDocument.reference.updateData(updateData)
    }
    
    func deleteExpense(id: String) async throws {
        try await expensesCollection.document(id).delete()
    }
    
    func checkIfUserExpenseExists(userId: String, categoryFieldName: String, category: Category, date: Date) async throws -> Expense? {
        return try await expensesCollection
            .whereField("userId", isEqualTo: userId)
            .whereField("dateTime", isEqualTo: date.formatToMonthYear())
            .whereField("categoryFieldName", isEqualTo: categoryFieldName)
            .whereField("category.codingKey", isEqualTo: category.codingKey)
            .getDocuments(as: Expense.self)
            .first
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            return try document.data(as: T.self)
        }
    }
}
