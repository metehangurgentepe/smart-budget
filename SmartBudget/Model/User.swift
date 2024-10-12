//
//  User.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation

struct User: Codable{
    var userId: String
    var currency: Currency
    var salary: Int?
}

enum Currency: String, Codable {
    case dolar = "$"
    case euro = "€"
    case turkish = "₺"
    case pound = "£"
    case yen = "¥"
    case rupee = "₹"
    case won = "₩"
    case franc = "₣"
    case krona = "kr"
    case real = "R$"
    case peso = "₱"
    case dinar = "د.إ"
    
    var flag: String {
        switch self {
        case .dolar: return "🇺🇸"
        case .euro: return "🇪🇺"
        case .turkish: return "🇹🇷"
        case .pound: return "🏴"
        case .yen: return "🇯🇵"
        case .rupee: return "🇮🇳"
        case .won: return "🇰🇷"
        case .franc: return "🇨🇭"
        case .krona: return "🇸🇪"
        case .real: return "🇧🇷"
        case .peso: return "🇲🇽"
        case .dinar: return "🇦🇪"
        }
    }
    
    var imageName: String {
        switch self {
        case .dolar: return "usd"
        case .euro: return "eur"
        case .turkish: return "try"
        case .pound: return "gbp"
        case .yen: return "jpy"
        default: return "defaultCurrency"
        }
    }
    
    var description: String {
        switch self {
        case .dolar: return "dolar"
        case .euro: return "euro"
        case .turkish: return "turkish"
        case .pound: return "pound"
        case .yen: return "yen"
        case .rupee: return "rupee"
        case .won: return "won"
        case .franc: return "franc"
        case .krona: return "krona"
        case .real: return "real"
        case .peso: return "peso"
        case .dinar: return "dinar"
        }
    }
    
    static var allCases: [Currency] = [.dolar, .euro, .dinar, .franc, .krona, .peso, .pound, .real, .rupee, .turkish, .won, .yen]
}
