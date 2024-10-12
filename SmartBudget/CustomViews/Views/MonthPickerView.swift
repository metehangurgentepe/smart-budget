//
//  MonthPickerView.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.04.2024.
//

import Foundation
import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var months = Array(1...12)
    var years = Array(2000...2030)
    
    var selectedMonth: Int {
        return months[selectedRow(inComponent: 0)]
    }
    
    var selectedYear: Int {
        return years[selectedRow(inComponent: 1)]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return months.count
        } else {
            return years.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(months[row])"
        } else {
            return "\(years[row])"
        }
    }
}
