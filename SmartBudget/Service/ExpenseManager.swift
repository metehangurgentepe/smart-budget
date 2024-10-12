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

class ExpenseManager{
    static let shared = ExpenseManager()
    private let expensesCollection = Firestore.firestore().collection("expenses")
    
    private init(){}
    
    func getExpense(id:String) async throws -> Expense {
        try await expensesCollection.document(id).getDocument(as: Expense.self)
    }
    
    
    func getAllExpensesByUser() async throws -> [Expense] {
        do{
            let userId = KeychainManager.get(account: "account")
            let documentId = String(decoding:userId ?? Data(), as:UTF8.self)
            let expenses: [Expense] = try await expensesCollection
                .whereField("userId", isEqualTo: documentId)
                .getDocuments(as: Expense.self)
            return expenses
        } catch {
            throw SBError.invalidResponse
        }
    }
    
    func getAllExpensesByUserByDate(date: String) async throws -> [Expense] {
        do{
            let userId = KeychainManager.get(account: "account")
            let documentId = String(decoding:userId ?? Data(), as:UTF8.self)
            let expenses: [Expense] = try await expensesCollection
                .whereField("userId", isEqualTo: documentId)
                .whereField("dateTime", isEqualTo: date)
                .getDocuments(as: Expense.self)
            return expenses
        } catch {
            throw SBError.invalidResponse
        }
    }
    
    
    func addMonthsToDate(date: String, monthsToAdd: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        guard let dateObject = dateFormatter.date(from: date) else {
            return nil
        }
        
        let calendar = Calendar.current
        if let futureDate = calendar.date(byAdding: .month, value: monthsToAdd, to: dateObject) {
            return dateFormatter.string(from: futureDate)
        } else {
            return nil
        }
    }
    
    
    func saveExpense(title: ExpenseTitle, price: Int, expensesDetail: [ExpenseDetail], date: String, repeatMonth: Int?) async throws {
        guard let userId = fetchUserId() else { throw SBError.invalidResponse }
        let db = Firestore.firestore()
        let collection = db.collection("expenses")
        
        let existingExpenses = try await collection
                .whereField("userId", isEqualTo: userId)
                .whereField("dateTime", isEqualTo: date)
                .getDocuments()
                .documents
                .compactMap { try? $0.data(as: Expense.self) }
        
        
        if let repeatCount = repeatMonth, repeatCount != 0 {
            try await saveRepeatingExpenses(title: title, price: price, expensesDetail: expensesDetail, baseDate: date, repeatCount: repeatCount, collection: collection, userId: userId)
        } else {
            try await saveSingleExpense(title: title, price: price, expensesDetail: expensesDetail, date: date, collection: collection, userId: userId)
        }
    }
    
    
    private func fetchUserId() -> String? {
        guard let userIdData = KeychainManager.get(account: "account") else { return nil }
        return String(decoding: userIdData, as: UTF8.self)
    }
    
    
    private func saveRepeatingExpenses(title: ExpenseTitle, price: Int, expensesDetail: [ExpenseDetail], baseDate: String, repeatCount: Int, collection: CollectionReference, userId: String) async throws {
        for month in 0..<repeatCount {
            if let newDate = addMonthsToDate(date: baseDate, monthsToAdd: month) {
                let existingExpense = try await checkIfUserExpenseByType(userId: userId, title: title, date: newDate)
                
                let newId = UUID().uuidString
                let expense = Expense(id: newId, title: title, price: price, expensesDetail: expensesDetail, userId: userId, dateTime: newDate, repeatMonth: repeatCount)
                
                if let existingExpense = existingExpense {
                    try await updateExistingExpense(existingExpense: existingExpense, newExpense: expense, collection: collection)
                } else {
                    try await saveExpenseToFirestore(expense: expense, collection: collection)
                }
            }
        }
    }
    
    
    private func saveSingleExpense(title: ExpenseTitle, price: Int, expensesDetail: [ExpenseDetail], date: String, collection: CollectionReference, userId: String) async throws {
        let id = UUID().uuidString
        let expense = Expense(id: id, title: title, price: price, expensesDetail: expensesDetail, userId: userId, dateTime: date)
        let existingExpense = try await checkIfUserExpenseByType(userId: userId, title: title, date: date)
        
        if let existingExpense = existingExpense {
            try await updateExistingExpense(existingExpense: existingExpense, newExpense: expense, collection: collection)
        } else {
            try await saveExpenseToFirestore(expense: expense, collection: collection)
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
    
    
    private func updateExistingExpense(existingExpense: Expense, newExpense: Expense, collection: CollectionReference) async throws {
        var combinedDetails = existingExpense.expensesDetail
        combinedDetails.append(contentsOf: newExpense.expensesDetail)
        
        var expenseDetailData: [[String: Any]] = []
        for detail in combinedDetails {
            expenseDetailData.append([
                "name": detail.name,
                "totalPrice": detail.totalPrice,
                "leftPrice": detail.leftPrice
            ])
        }
        
        let updatedPrice = existingExpense.price + newExpense.price
        try await collection.document(existingExpense.id).updateData([
            "price": updatedPrice,
            "expensesDetail": expenseDetailData
        ])
    }
    
    
    func updateExpenseDetail(details: [ExpenseDetail], id: String) async throws{
        let expenseQuery = expensesCollection.whereField("id", isEqualTo: id)
        let expenseSnapshot = try await expenseQuery.getDocuments()
        
        guard let expenseDocument = expenseSnapshot.documents.first else {
            throw SBError.invalidResponse
        }
        
        var expenseDetail: [[String:Any]] = []
        
        for detail in details {
            let detailData: [String: Any] = [
                "name": detail.name,
                "totalPrice": detail.totalPrice,
                "leftPrice": detail.leftPrice
            ]
            expenseDetail.append(detailData)
        }
        
        try await expenseDocument.reference.updateData(["expensesDetail": expenseDetail])
    }
    
    
    func deleteExpense(id: String) async throws{
        try await expensesCollection.document(id).delete()
    }
    
    
    func deleteExpenseDetail(id: String, detail: ExpenseDetail) async throws{
        let document = try await expensesCollection.whereField("id", isEqualTo: id).getDocuments().documents.first
        
        var updatedDetails = document?.data()["expensesDetail"] as? [ExpenseDetail] ?? []
        updatedDetails.removeAll { $0 == detail }
        
        try await document?.reference.updateData(["expensesDetail" : updatedDetails])
    }
    
    
    func checkIfUserExpenseByType(userId: String, title: ExpenseTitle, date:String) async throws -> Expense? {
        
        return try await expensesCollection.whereField("userId", isEqualTo: userId)
            .whereField("dateTime", isEqualTo: date)
            .whereField("title", isEqualTo: title.rawValue)
            .getDocuments(as: Expense.self)
            .first
    }
}


extension Query {
    func getDocuments<T>(as type:T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map { document in
            return try document.data(as: T.self)
        }
    }
}
