//
//  CurrencyManager.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.10.2024.
//

import Foundation

class CurrencyManager: ObservableObject {
    static let shared = CurrencyManager()
    
    @Published private(set) var selectedCurrency: Currency {
        didSet {
            UserDefaults.standard.set(selectedCurrency.rawValue, forKey: "selectedCurrency")
        }
    }
    
    private init() {
        if let savedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency"),
           let currency = Currency(rawValue: savedCurrency) {
            self.selectedCurrency = currency
        } else {
            self.selectedCurrency = .dolar 
        }
    }
    
    func setSelectedCurrency(_ currency: Currency) {
        selectedCurrency = currency
    }
}
