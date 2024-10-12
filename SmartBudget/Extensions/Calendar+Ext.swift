//
//  Calendar+Ext.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.04.2024.
//

import Foundation

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(for date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(for: date))!
    }
}
