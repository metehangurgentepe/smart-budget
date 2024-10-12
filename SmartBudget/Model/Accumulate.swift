//
//  Accumulate.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import Foundation

struct Accumulate: Codable, Equatable, Hashable{
    var id: String
    var name: String
    var price: Int
    var dateTime: String
    var userId: String
    var currency: Currency
}
