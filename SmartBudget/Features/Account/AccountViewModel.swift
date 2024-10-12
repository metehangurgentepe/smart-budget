//
//  AccountViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 2.07.2024.
//

import Foundation


class AccountViewModel {
    weak var delegete: AccountViewModelDelegate?
    
    func saveSalary(salary: Int, currency: Currency) async throws {
        do{
            self.delegete?.handleViewModelOutput(.setLoading(true))
            try await UserManager.shared.setSalary(salary: salary, currency: currency)
            self.delegete?.handleViewModelOutput(.setLoading(false))
        } catch {
            self.delegete?.handleViewModelOutput(.showError(error as! SBError))
        }
    }
}
