//
//  CardCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//


import UIKit
import SnapKit

class CardCell: UITableViewCell {
    static let identifier = "CardCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(noteLabel)
        
        iconContainer.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconContainer.snp.right).offset(12)
            make.top.equalTo(iconContainer)
            make.right.equalTo(priceLabel.snp.left).offset(-8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(nameLabel)
            make.width.lessThanOrEqualTo(100)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.right.equalTo(priceLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with expense: Expense) {
        nameLabel.text = expense.category.name
        priceLabel.text = "\(expense.price)"
        noteLabel.text = expense.note
        
        iconImageView.image = UIImage(systemName: expense.category.icon)
        
//        if let color = UIColor(named: expense.category.colorName) {
//            iconContainer.backgroundColor = color.withAlphaComponent(0.2)
//            iconImageView.tintColor = color
//        }
    }
}
