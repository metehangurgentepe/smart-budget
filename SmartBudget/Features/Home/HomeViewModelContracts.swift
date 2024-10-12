//
//  HomeViewModelContracts.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 27.03.2024.
//

import Foundation
import UIKit


protocol HomeViewModelDelegate: AnyObject{
    func handleViewModelOutput(_ output: ExpenseListViewModelOutput)
    func navigate(to navigationType: NavigationType)
}

enum NavigationType {
    case details(Int)
    case goToVC(UIViewController)
    case present(UIViewController)
}

enum ExpenseListViewModelOutput: Equatable {
    case setLoading(Bool)
    case showExpenseList([Expense])
    case showError(SBError)
    case emptyList
    case reloadCollectionView([Expense])
    case showUser(User?)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? {get set}
    func getExpenses(date: String)
    func selectRecipe(at index: Int)
}

protocol HomeViewDelegate: AnyObject {
    
}
