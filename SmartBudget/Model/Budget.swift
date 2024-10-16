//
//  Budget.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.10.2024.
//

import Foundation


struct Budget: Codable {
    let id: String
    let userId: String
    let amount: Double
    let currency: String
    let startDate: Date
    let endDate: Date
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: startDate)
    }
}
