//
//  AddExpenseViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation
import Firebase


class AddExpenseViewModel {
    private(set) var title: ExpenseTitle?
    private(set) var name: String = ""
    private(set) var price: Int?
    
    weak var delegate: AddExpenseViewDelegate?
    
    func addExpense(title: ExpenseTitle, price: Int, name: String, date: String, leftPrice: Int, repeatMonth: Int?) {
        Task{ [weak self] in
            guard let self = self else { return }
            self.delegate?.handleViewModelOutput(.setLoading(true))
            
            do{
                try await ExpenseManager.shared.saveExpense(title: title,
                                                            price: price,
                                                            expensesDetail: [ExpenseDetail(name: name , totalPrice: price, leftPrice: leftPrice)],
                                                            date: date, repeatMonth: repeatMonth)
                self.delegate?.handleViewModelOutput(.setLoading(false))
                self.delegate?.handleViewModelOutput(.successSavingExpense(true))
            } catch {
                self.delegate?.handleViewModelOutput(.showError(error))
                self.delegate?.handleViewModelOutput(.successSavingExpense(true))
            }
        }
    }
}
