//
//  AddAccumulateViewModelContracts.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 14.05.2024.
//

import Foundation

protocol AddAccumulateViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: AddAccumulateViewModelOutput)
}

enum AddAccumulateViewModelOutput: Equatable {
    case setLoading(Bool)
    case showError(SBError)
    case addAccumulate
    case dismissContainerView
}

protocol AddAccumulateViewModelProtocol {
    var delegate: AddAccumulateViewModelDelegate? { get set }
}

protocol AddAccumulateDelegate: AnyObject {
    func didAddAccumulate()
}
