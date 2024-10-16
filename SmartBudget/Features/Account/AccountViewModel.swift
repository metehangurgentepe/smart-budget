//
//  AccountViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 2.07.2024.
//

import Foundation


class AccountViewModel {
    weak var delegate: AccountViewModelDelegate?
    
    private let budgetManager: BudgetManager
    private let userManager: UserManager
    
    init(budgetManager: BudgetManager = .shared, userManager: UserManager = .shared) {
        self.budgetManager = budgetManager
        self.userManager = userManager
    }
    
    var currencies: [Currency] {
        return Currency.allCases
    }
    
    func saveBudget(amount: Double, currency: Currency, startDate: Date, endDate: Date) {
        guard let userId = userManager.getUserId() else {
            delegate?.handleViewModelOutput(.showError(.apiUsageError))
            return
        }
        
        let newBudget = Budget(
            id: UUID().uuidString,
            userId: userId,
            amount: amount,
            currency: currency.rawValue,
            startDate: startDate,
            endDate: endDate
        )
        
        Task {
            do {
                try await budgetManager.saveBudget(newBudget)
                await MainActor.run {
                    delegate?.handleViewModelOutput(.didSaveBudget(true))
                }
            } catch {
                await MainActor.run {
                    delegate?.handleViewModelOutput(.didSaveBudget(false))
                }
            }
        }
    }
    
    func validateInput(amount: String?, currency: Currency?, startDate: Date, endDate: Date) -> Bool {
        guard let amount = amount, !amount.isEmpty,
              let _ = Double(amount),
              let _ = currency else {
            return false
        }
        
        return startDate <= endDate
    }
}
