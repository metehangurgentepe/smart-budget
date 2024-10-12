//
//  AccumulateCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import UIKit

class AccumulateCell: UITableViewCell {
    static let identifier = "AccumulateCell"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    func set(accumulate: Accumulate) {
        nameLabel.text = accumulate.name
        priceLabel.text = "\(accumulate.currency.rawValue)\(accumulate.price)"
        
        let stack = UIStackView()
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(priceLabel)
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        
        addSubview(stack)
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
