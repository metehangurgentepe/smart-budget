//
//  AddExpenseViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//
import Foundation
import Firebase

class AddExpenseViewModel {
    private(set) var categoryField: CategoryField?
    private(set) var category: Category?
    private(set) var price: Int?
    private(set) var note: String?
    private(set) var date: Date
    private(set) var repeatInterval: RepeatInterval?
    
    weak var delegate: AddExpenseViewDelegate?
    
    init() {
        self.date = Date()
    }
    
    func setCategoryField(_ categoryField: CategoryField) {
        self.categoryField = categoryField
    }
    
    func setCategory(_ category: Category) {
        self.category = category
    }
    
    func setPrice(_ price: Int) {
        self.price = price
    }
    
    func setNote(_ note: String) {
        self.note = note
    }
    
    func setDate(_ date: Date) {
        self.date = date
    }
    
    func setRepeatInterval(_ repeatInterval: RepeatInterval) {
        self.repeatInterval = repeatInterval
    }
    
    func addExpense() {
        Task { [weak self] in
            guard let self = self else { return }
            guard let category = self.category else {
                return
            }
            
            self.delegate?.handleViewModelOutput(.setLoading(true))
            
            do {
                try await ExpenseManager.shared.saveExpense(
                    categoryFieldName: categoryField?.name ?? "",
                    category: category,
                    price: price ?? 0,
                    note: self.note,
                    date: self.date,
                    repeatInterval: self.repeatInterval
                )
                
                self.delegate?.handleViewModelOutput(.setLoading(false))
                self.delegate?.handleViewModelOutput(.successSavingExpense(true))
            } catch {
                self.delegate?.handleViewModelOutput(.showError(error))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            }
        }
    }
    
    func updateExpense(id: String) {
        Task{ [weak self] in
            guard let self else { return }
            do {
                try await ExpenseManager.shared.updateExpense(id: id, price: price ?? 0, note: note, date: date)
                self.delegate?.handleViewModelOutput(.setLoading(false))
                self.delegate?.handleViewModelOutput(.successSavingExpense(true))
            } catch {
                self.delegate?.handleViewModelOutput(.showError(error))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            }
        }
    }
}
