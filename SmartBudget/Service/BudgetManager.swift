//
//  BudgetManager.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.10.2024.
//

import Foundation
import Foundation
import FirebaseFirestore

class BudgetManager {
    static let shared = BudgetManager()
    private let db = Firestore.firestore()
    private let userId: String?
    
    init(userId: String? = UserManager.shared.getUserId()) {
        self.userId = userId
    }
    
    func saveBudget(_ budget: Budget) async throws {
        try db.collection("budgets").document(budget.id).setData(from: budget)
    }
    
    func getBudgets( startDate: Date, endDate: Date) async throws -> [Budget] {
        let snapshot = try await db.collection("budgets")
            .whereField("userId", isEqualTo: userId!)
            .whereField("startDate", isGreaterThanOrEqualTo: startDate)
            .whereField("endDate", isLessThanOrEqualTo: endDate)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Budget.self) }
    }
    
    func getBudgetForMonth(date: Date) async throws -> Budget? {
        guard let userId = userId else {
            throw BudgetError.unauthorizedAccess
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            throw BudgetError.invalidDate
        }

        let startOfMonthExact = calendar.startOfDay(for: startOfMonth)
        let endOfMonthExact = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endOfMonth)!
        
        let snapshot = try await db.collection("budgets")
            .whereField("userId", isEqualTo: userId)
            .whereField("startDate", isLessThanOrEqualTo: endOfMonthExact)
            .whereField("endDate", isGreaterThanOrEqualTo: startOfMonthExact)
            .getDocuments()

        let budgets = try snapshot.documents.compactMap { try $0.data(as: Budget.self) }
        
        let filteredBudgets = budgets.filter { budget in
            return budget.startDate <= endOfMonthExact && budget.endDate >= startOfMonthExact
        }

        return filteredBudgets.max { budget1, budget2 in
            let duration1 = calendar.dateComponents([.day], from: max(budget1.startDate, startOfMonthExact), to: min(budget1.endDate, endOfMonthExact)).day ?? 0
            let duration2 = calendar.dateComponents([.day], from: max(budget2.startDate, startOfMonthExact), to: min(budget2.endDate, endOfMonthExact)).day ?? 0
            return duration1 < duration2
        }
    }
}

enum BudgetError: Error {
    case insufficientFunds
    case invalidDate
    case categoryNotFound
    case budgetNotFound
    case transactionFailed
    case invalidAmount
    case budgetExceeded
    case duplicateEntry
    case noBudgetForMonth
    case unauthorizedAccess
    
    var localizedDescription: String {
        switch self {
        case .insufficientFunds: return "LocaleKeys.Error.insufficientFunds.rawValue.locale()"
        case .invalidDate: return "LocaleKeys.Error.invalidDate.rawValue.locale()"
        case .categoryNotFound: return "LocaleKeys.Error.categoryNotFound.rawValue.locale()"
        case .budgetNotFound: return "LocaleKeys.Error.budgetNotFound.rawValue.locale()"
        case .transactionFailed: return "LocaleKeys.Error.transactionFailed.rawValue.locale()"
        case .invalidAmount: return "LocaleKeys.Error.invalidAmount.rawValue.locale()"
        case .budgetExceeded: return "LocaleKeys.Error.budgetExceeded.rawValue.locale()"
        case .duplicateEntry: return "LocaleKeys.Error.duplicateEntry.rawValue.locale()"
        case .noBudgetForMonth: return "LocaleKeys.Error.noBudgetForMonth.rawValue.locale()"
        case .unauthorizedAccess: return "LocaleKeys.Error.unauthorizedAccess.rawValue.locale()"
        }
    }
    
    var errorUserInfo: [String: Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

    
