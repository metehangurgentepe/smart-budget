//
//  String+Ext.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.10.2024.
//

import Foundation


extension String {
    func toDate(withFormat format: String = "MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: self)
    }
    
    func toFormattedDateString(fromFormat: String = "MM/yyyy", toFormat: String = "MMMM yyyy") -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFormat
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            
            guard let date = dateFormatter.date(from: self) else {
                return nil
            }
            
            dateFormatter.dateFormat = toFormat
            return dateFormatter.string(from: date)
        }
}
