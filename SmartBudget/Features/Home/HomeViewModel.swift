//
//  HomeViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 27.03.2024.
//

import Foundation
import UIKit

class HomeViewModel: HomeViewModelProtocol{
    weak var delegate: HomeViewModelDelegate?
    private(set) var expenses : [Expense] = []
    private(set) var isEmptyRecipe: Bool = true
    private(set) var user: User?
    
    @MainActor
    func getExpenses(date: String) {
        delegate?.handleViewModelOutput(.setLoading(true))
        
        Task{ [weak self] in
            guard let self = self else { return }
            do {
                self.expenses = try await ExpenseManager.shared.getAllExpensesByUserByDate(date: date)
                
                if !self.expenses.isEmpty {
                    let arr = self.expenses.sorted(by: {$0.id < $1.id})
                    self.delegate?.handleViewModelOutput(.reloadCollectionView(arr))
                    self.delegate?.handleViewModelOutput(.setLoading(false))
                    
                } else {
                    self.delegate?.handleViewModelOutput(.emptyList)
                    self.delegate?.handleViewModelOutput(.setLoading(false))
                }
            } catch{
                self.delegate?.handleViewModelOutput(.showError(error as! SBError))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            }
        }
    }
    
    func getUserMonthlyBudget() {
        delegate?.handleViewModelOutput(.setLoading(true))
        
        Task{ [weak self] in
            guard let self = self else { return }
            do {
                self.user = try await UserManager.shared.getUser()
                self.delegate?.handleViewModelOutput(.showUser(user))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            } catch {
                self.delegate?.handleViewModelOutput(.showError(error as! SBError))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            }
        }
    }
    
    
    func selectRecipe(at index: Int) {
        delegate?.navigate(to: .details(index))
    }
}

extension ExpenseListViewModelOutput {
    static func == (lhs: ExpenseListViewModelOutput, rhs: ExpenseListViewModelOutput) -> Bool {
        switch (lhs, rhs) {
        case (.setLoading(let a), .setLoading(let b)):
            return a == b
        case (.showExpenseList(let a), .showExpenseList(let b)):
            return a == b
        default:
            return false
        }
    }
}


