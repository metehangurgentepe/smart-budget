//
//  Expense.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 3.04.2024.
//

import Foundation
import UIKit
import Firebase

struct Expense: Codable, Equatable, Hashable {
    var id: String
//    var groupId: String
    var title: ExpenseTitle
    var icon: ExpenseIcon?
    var price: Int
    var expensesDetail: [ExpenseDetail]
    var userId: String
    var dateTime: String
    var repeatMonth: Int?
    
    
    func iconForTitle(_ title: ExpenseTitle) -> ExpenseIcon? {
        switch title {
        case .food:
            return .food
        case .shopping:
            return .shopping
        case .household:
            return .household
        case .bill:
            return .bill
        case .entertainment:
            return .entertainment
        case .transportation:
            return .transportation
        case .health:
            return .health
        case .travel:
            return .travel
        case .education:
            return .education
        case .gift:
            return .gift
        case .other:
            return .other
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, icon, price, expensesDetail, userId, dateTime, repeatMonth
    }
    
    static func == (lhs: Expense, rhs: Expense) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ExpenseDetail: Codable, Hashable {
    var name: String
    var totalPrice: Int
    var leftPrice: Int
}

enum ExpenseTitle: String, Codable, Hashable {
    case food = "Food & Beverage"
    case shopping = "Shopping"
    case household = "Household"
    case bill = "Bill"
    case entertainment = "Entertainment"
    case transportation = "Transportation"
    case health = "Health and Care"
    case travel = "Travel"
    case education = "Education"
    case gift = "Gift and Donations"
    case other = "Other"
    
    static let allCases: [ExpenseTitle] = [.food, .shopping, .household, .bill, .entertainment, .transportation, .travel, .education, .gift, .other]
}

enum ExpenseIcon: String, Codable, Hashable {
    case food = "fork.knife"
    case shopping = "creditcard"
    case household = "house.lodge.fill"
    case bill = "list.bullet.clipboard"
    case entertainment = "theatermasks"
    case transportation = "bus"
    case health = "heart.circle.fill"
    case travel = "airplane"
    case education = "graduationcap"
    case gift = "gift"
    case other = "ellipsis.circle"
    
    static let allCases: [ExpenseIcon] = [.food, .shopping, .household, .bill, .entertainment, .transportation, .travel, .education, .gift, .other]
}

