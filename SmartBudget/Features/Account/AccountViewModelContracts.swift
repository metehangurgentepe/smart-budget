//
//  AccountViewModelContracts.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 2.07.2024.
//

import Foundation


protocol AccountViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: AccountViewModelOutput)
}

enum AccountViewModelOutput: Equatable {
    case setLoading(Bool)
    case showError(SBError)
    case saveSalary
    case didSaveBudget(Bool)
}

protocol AccountViewModelProtocol {
    var delegate: AccountViewModelDelegate? { get set }
}
