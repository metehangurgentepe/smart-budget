//
//  ExpenseDetailCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 24.04.2024.
//

import UIKit
import SnapKit

protocol ExpenseDetailCellDelegate: AnyObject {
    func updateExpense(price: Int, note: String?, indexPath: IndexPath)
}

class ExpenseDetailCell: UITableViewCell {
    static let identifier = "ExpenseDetailCell"
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
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
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    weak var delegate: ExpenseDetailCellDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconContainer.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(4)
            make.width.height.equalTo(50)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconContainer)
            make.left.equalTo(iconContainer.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainer)
            make.right.equalToSuperview().offset(-6)
        }
    }
    
    func configure(with expense: Expense) {
        nameLabel.text = expense.category.name
        iconImageView.image = UIImage(systemName: expense.category.icon)
    }
}
