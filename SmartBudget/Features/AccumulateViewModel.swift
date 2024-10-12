// AccumulateViewModel.swift

import Foundation

class AccumulateViewModel: AccumulateViewModelProtocol {
    var accumulate: [Accumulate] = []
    weak var delegate: AccumulateViewModelDelegate?
    
    func getAccumulate(date: String) {
        Task{
            self.delegate?.handleViewModelOutput(.setLoading(true))
            do {
                let accumulate = try await AccumulateManager.shared.getAccumulatesByUserByDate(date: date)
                self.delegate?.handleViewModelOutput(.showAccumulateList(accumulate))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            } catch {
                self.delegate?.handleViewModelOutput(.showError(.serializationError))
                self.delegate?.handleViewModelOutput(.setLoading(false))
            }
        }
    }
    
    func deleteAccumulate(id: String) {
        Task {
            do {
                try await AccumulateManager.shared.deleteExpense(id: id)
                self.accumulate.removeAll(where: {$0.id == id})
                self.delegate?.handleViewModelOutput(.reloadCollectionView)
            } catch {
                self.delegate?.handleViewModelOutput(.showError(.serializationError))
            }
        }
    }
    
    func selectAccumulate(at index: Int) {
        
    }
    
    func getAccumulateByDate(date: String) async throws {
        self.delegate?.handleViewModelOutput(.setLoading(true))
        do {
            let accumulate = try await AccumulateManager.shared.getAccumulatesByUserByDate(date: date)
            self.delegate?.handleViewModelOutput(.showAccumulateList(accumulate))
            self.delegate?.handleViewModelOutput(.setLoading(false))
        } catch {
            self.delegate?.handleViewModelOutput(.showError(.serializationError))
            self.delegate?.handleViewModelOutput(.setLoading(false))
        }
    }
}
