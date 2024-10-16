//
//  PriceTextField.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 14.10.2024.
//

import Foundation
import UIKit
import SnapKit

class PriceTextField: UITextField {
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline).withSize(20)
        return label
    }()
    
    private var rawValue: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(currencyLabel)
        font = .preferredFont(forTextStyle: .headline).withSize(50)
        textAlignment = .center
        keyboardType = .numberPad
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
        tintColor = .tomato
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCurrencyLabelPosition()
    }
    
    private func updateCurrencyLabelPosition() {
        let labelSize = currencyLabel.intrinsicContentSize
        let textSize = (text as NSString? ?? "").size(withAttributes: [.font: font!])
        if let text = text, !text.isEmpty {
            let x = (bounds.width - textSize.width - labelSize.width) / 2 - 5
            let y = bounds.height - textSize.height
            currencyLabel.frame = CGRect(x: x, y: y - labelSize.height, width: labelSize.width, height: labelSize.height)
        } else {
            let x = (bounds.width - labelSize.width) / 2
            let y = bounds.height - labelSize.height
            currencyLabel.frame = CGRect(x: x, y: y - labelSize.height, width: labelSize.width, height: labelSize.height)
        }
    }
    
    @objc private func textDidChange() {
        formatText()
        updateCurrencyLabelPosition()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    private func formatText() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        
        if let formattedString = formatter.string(from: NSNumber(value: rawValue)) {
            text = formattedString
        } else {
            text = "0"
        }
    }
}

extension PriceTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            rawValue /= 10
            formatText()
            return false
        }
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        guard rawValue < 10000000000 else {
            return false
        }
        
        rawValue = rawValue * 10 + (Int(string) ?? 0)
        formatText()
        return false
    }
}
