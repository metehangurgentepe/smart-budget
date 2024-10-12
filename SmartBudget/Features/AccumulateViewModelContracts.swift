// AccumulateViewModelContracts.swift

import Foundation

protocol AccumulateViewModelDelegate: AnyObject {
    func handleViewModelOutput(_ output: AccumulateViewModelOutput)
}

enum AccumulateViewModelOutput: Equatable {
    case setLoading(Bool)
    case showAccumulateList([Accumulate])
    case showError(SBError)
    case emptyList
    case reloadCollectionView
}

protocol AccumulateViewModelProtocol {
    var delegate: AccumulateViewModelDelegate? { get set }
    func getAccumulate(date: String)
    func selectAccumulate(at index: Int)
}
