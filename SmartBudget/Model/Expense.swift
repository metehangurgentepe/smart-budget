//
//  Expense.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 3.04.2024.
//

import Foundation
import UIKit

struct Expense: Codable, Equatable, Hashable {
    var id: String
    var categoryFieldName: String
    var category: Category
    var price: Int
    var note: String?
    var userId: String
    var dateTime: String
    var repeatInterval: RepeatInterval?
    
    static func == (lhs: Expense, rhs: Expense) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Category: Codable, Hashable {
    let name: String
    let icon: String
    let codingKey: String
}

struct CategoryField: Codable, Hashable {
    let name: String
    let categories: [Category]
    let codingKey: String
}

enum RepeatInterval: String, Codable, CaseIterable {
    case never
    case daily
    case weekly
    case monthly
    case yearly
}
