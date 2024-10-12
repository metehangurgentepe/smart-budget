//
//  Date+Ext.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 3.04.2024.
//

import Foundation
import Firebase


extension Date{
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func formatDate() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formatToMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formatMonthYear() -> String{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        let year = components.year ?? 0
        let month = components.month ?? 0
        
        return "\(month)/\(year)"
    }
}

public func dateToTimestamp(_ date: Date) -> Timestamp {
    return Timestamp(date: date)
}
