//
//  AddExpenseViewModelContracts.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 5.04.2024.
//

import Foundation

enum AddExpenseViewModelOutput: Equatable {
    case setLoading(Bool)
    case showError(Error)
    case saveExpense
    case successSavingExpense(Bool)
    
    static func == (lhs: AddExpenseViewModelOutput, rhs: AddExpenseViewModelOutput) -> Bool {
        switch (lhs, rhs) {
        case (.setLoading(let a), .setLoading(let b)):
            return a == b
        default:
            return false
        }
    }
}

protocol AddExpenseViewModelProtocol {
    var delegate: AddExpenseViewDelegate? { get set }
    func saveExpense()
}

protocol AddExpenseViewDelegate: AnyObject {
    func handleViewModelOutput(_ output: AddExpenseViewModelOutput)
}

protocol AddExpenseDelegate: AnyObject {
    func didAddExpense()
}
