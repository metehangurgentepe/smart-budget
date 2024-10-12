//
//  AddAccumulateViewModel.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import Foundation

class AddAccumulateViewModel {
    weak var delegate: AddAccumulateViewModelDelegate?
    
    func saveAccumulate(name:String, price: Int, currency: Currency) async throws{
        do{
            let date = Date()
            let formattedDate = date.formatToMonthYear()
            try await AccumulateManager.shared.saveAccumulate(price: price, date: formattedDate, name: name,currency: currency)
            
            self.delegate?.handleViewModelOutput(.addAccumulate)
            self.delegate?.handleViewModelOutput(.setLoading(false))
            self.delegate?.handleViewModelOutput(.dismissContainerView)
        } catch {
            self.delegate?.handleViewModelOutput(.showError(error as! SBError))
        }
    }
}
