//
//  Constants.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import Foundation
import UIKit

struct Constants {
    enum Links: String {
        case appStoreLink = "https://apps.apple.com/tr/app/whichfood/id6467032293?l=tr"
        case eventierLink = "https://apps.apple.com/tr/app/eventier/id6462756481?l=tr"
        case email = "metehangurgentepe@gmail.com"
        case termsOfService = "https://gist.github.com/metehangurgentepe/ebe86cb7265a2063500ec8fee22baba3#file-terms_of_service-md"
        case privacyPolicy = "https://gist.github.com/metehangurgentepe/ea46f5a99eba8a600e6a6bf1fe522460#file-privacy-policy-md"
        case website = "https://superlative-bienenstitch-1a1e1f.netlify.app/"
    }
}

struct CategoryConstants {
    static let all: [CategoryField] = [
        CategoryField(name: "Entertainment", categories: [
            Category(name: "Movies", icon: "film", codingKey: "movies"),
            Category(name: "Music", icon: "music.note", codingKey: "music"),
            Category(name: "Games", icon: "gamecontroller", codingKey: "games"),
            Category(name: "Books", icon: "book", codingKey: "books"),
            Category(name: "Sports", icon: "sportscourt", codingKey: "sports"),
            Category(name: "Theater", icon: "theatermasks", codingKey: "theater"),
            Category(name: "Concerts", icon: "music.mic", codingKey: "concerts")
        ], codingKey: "entertainment"),
        
        CategoryField(name: "Food", categories: [
            Category(name: "Groceries", icon: "cart", codingKey: "groceries"),
            Category(name: "Restaurant", icon: "fork.knife", codingKey: "restaurant" ),
            Category(name: "Cafe", icon: "cup.and.saucer", codingKey: "cafe"),
            Category(name: "Fast Food", icon: "bag", codingKey: "fastfood"),
            Category(name: "Bakery", icon: "birthday.cake", codingKey: "bakery"),
        ], codingKey: "food"),
        
        CategoryField(name: "Transportation", categories: [
            Category(name: "Public Transit", icon: "bus", codingKey: "publictransit"),
            Category(name: "Taxi", icon: "car", codingKey: "taxi"),
            Category(name: "Fuel", icon: "fuelpump", codingKey: "fuel"),
            Category(name: "Parking", icon: "parkingsign", codingKey: "parking"),
            Category(name: "Bicycle", icon: "bicycle", codingKey: "bicycle"),
        ], codingKey: "transportation"),
        
        CategoryField(name: "Shopping", categories: [
            Category(name: "Clothes", icon: "tshirt", codingKey: "clothes"),
            Category(name: "Electronics", icon: "desktopcomputer", codingKey: "electronics"),
            Category(name: "Gifts", icon: "gift", codingKey: "gifts"),
            Category(name: "Home Decor", icon: "house", codingKey: "homedecor"),
            Category(name: "Beauty", icon: "paintbrush", codingKey: "beauty"),
        ], codingKey: "shopping"),
        
        CategoryField(name: "Health", categories: [
            Category(name: "Doctor", icon: "stethoscope", codingKey: "doctor"),
            Category(name: "Pharmacy", icon: "cross.case", codingKey: "pharmacy"),
            Category(name: "Gym", icon: "figure.walk", codingKey: "gym"),
            Category(name: "Spa", icon: "leaf", codingKey: "spa"),
            Category(name: "Mental Health", icon: "brain", codingKey: "mentalhealth"),
        ], codingKey: "health"),
        
        CategoryField(name: "Education", categories: [
            Category(name: "Tuition", icon: "graduationcap", codingKey: "tuition"),
            Category(name: "Books", icon: "book.closed", codingKey: "educationbooks"),
            Category(name: "Courses", icon: "chart.bar.doc.horizontal", codingKey: "courses"),
            Category(name: "School Supplies", icon: "pencil.and.ruler", codingKey: "schoolsupplies"),
        ], codingKey: "education"),
        
        CategoryField(name: "Utilities", categories: [
            Category(name: "Electricity", icon: "bolt", codingKey: "electricity"),
            Category(name: "Water", icon: "drop", codingKey: "water"),
            Category(name: "Gas", icon: "flame", codingKey: "gas"),
            Category(name: "Internet", icon: "wifi", codingKey: "internet"),
            Category(name: "Phone", icon: "phone", codingKey: "phone"),
        ], codingKey: "utilities"),
        
        CategoryField(name: "Personal Care", categories: [
            Category(name: "Haircut", icon: "scissors", codingKey: "haircut"),
            Category(name: "Cosmetics", icon: "heart", codingKey: "cosmetics"),
            Category(name: "Laundry", icon: "washer", codingKey: "laundry"),
            Category(name: "Gym", icon: "figure.walk", codingKey: "personalgym"),
        ], codingKey: "personal")
    ]
}


struct ColorsConstants {
    static let all: [UIColor] = [.tomato, .mediumSeaGreen, .customOrange, .dodgetBlue, .hotPink, .indigo, .mediumSpringGreen, .redOrange]
}

extension UIColor {
    static let tomato = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
    static let mediumSeaGreen = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1)  // Medium Sea Green
    static let customOrange =  UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)   // Orange
    static let dodgetBlue = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)  // Dodger Blue
    static let hotPink = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1) // Hot Pink
    static let indigo =  UIColor(red: 75/255, green: 0/255, blue: 130/255, alpha: 1)    // Indigo
    static let mediumSpringGreen = UIColor(red: 0/255, green: 250/255, blue: 154/255, alpha: 1)   // Medium Spring Green
    static let redOrange = UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
    
    static let customGray = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(red: 72/255, green: 72/255, blue: 74/255, alpha: 1)  // Dark Mode Gray
        default:
            return UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)  // Light Mode Gray
        }
    }
}
