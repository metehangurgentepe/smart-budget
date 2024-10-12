//
//  ExpenseDetailViewModelContracts.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 8.04.2024.
//

import Foundation

enum ExpenseDetailViewModelOutput: Equatable {
    static func == (lhs: ExpenseDetailViewModelOutput, rhs: ExpenseDetailViewModelOutput) -> Bool {
        switch (lhs, rhs) {
        case (.setLoading(let a), .setLoading(let b)):
            return a == b
        case (.getExpense(let a), .getExpense(let b)):
            return a == b
        default:
            return false
        }
    }
    
    case setLoading(Bool)
    case showError(SBError)
    case getExpense(Expense)
    case saveExpense
}

protocol ExpenseDetailViewModelProtocol {
    var delegate: ExpenseDetailViewDelegate? { get set }
    func getExpense()
}

protocol ExpenseDetailViewDelegate: AnyObject {
    func handleViewModelOutput(_ output: ExpenseDetailViewModelOutput)
}
