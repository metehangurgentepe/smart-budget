//
//  ExpenseDetailViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation

class ExpenseDetailViewModel {
    var id: String!
    private(set) var expense: Expense?
    weak var delegate: ExpenseDetailViewDelegate?
    
    init(id: String) {
        self.id = id
    }
    
    func getExpense() {
        Task {
            let expense = try await ExpenseManager.shared.getExpense(id: id)
            self.delegate?.handleViewModelOutput(.getExpense(expense))
        }
    }
    
    
    func updateExpense(details: [ExpenseDetail], id: String) throws {
        Task {
            try details.compactMap({ detail in
                if detail.leftPrice > detail.totalPrice {
                    self.delegate?.handleViewModelOutput(.showError(.totalPriceMustBeBigger))
                    throw SBError.totalPriceMustBeBigger
                }
            })
            try await ExpenseManager.shared.updateExpenseDetail(details: details, id: id)
            self.delegate?.handleViewModelOutput(.saveExpense)
        }
    }
    
    
    func deleteExpenseDetail() {
        Task{
        }
    }
}
