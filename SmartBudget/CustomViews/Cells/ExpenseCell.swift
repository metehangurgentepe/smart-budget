//
//  ExpenseCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 22.04.2024.
//

import UIKit

class ExpenseCell: UICollectionViewCell {
    static let identifier = "ExpenseCell"
    let image = UIImageView()
    
    let imageContainer = UIView()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(22)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let detailsContainerView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        nameLabel.text = nil
        imageContainer.backgroundColor = nil
        
        contentView.subviews.forEach { subview in
            if subview != imageContainer && subview != nameLabel {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func set(expense: Expense, color: UIColor) {
        prepareForReuse()
        
        image.image = UIImage(systemName: expense.iconForTitle(expense.title)?.rawValue ?? "")
        image.tintColor = color
        
        imageContainer.backgroundColor = color.withAlphaComponent(0.2)
        imageContainer.layer.cornerRadius = 10
        imageContainer.clipsToBounds = true
        
        nameLabel.text = expense.title.rawValue
        
        for subview in contentView.subviews {
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
        
        var previousView: UIView = imageContainer
        
        for expenseDetail in expense.expensesDetail {
            let expenseNameLabel: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .headline).withSize(15)
                return label
            }()
            let expensePriceLabel: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .headline).withSize(15)
                return label
            }()
            let expenseLeftPriceLabel: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .caption1)
                label.textColor = .systemGray3
                label.textAlignment = .right
                return label
            }()
            let progressView = UIProgressView()
            
            expenseNameLabel.tag = 100
            progressView.tag = 100
            expensePriceLabel.tag = 100
            expenseLeftPriceLabel.tag = 100
            
            let expenseRatio1: Float = Float(expenseDetail.leftPrice) / Float(expenseDetail.totalPrice)
            progressView.setProgress(expenseRatio1, animated: true)
            progressView.tintColor = color
            
            expenseNameLabel.text = expenseDetail.name
            expensePriceLabel.text = String(expenseDetail.totalPrice)
            expenseLeftPriceLabel.text = "Left \(expenseDetail.leftPrice)"
            
            contentView.addSubview(expenseNameLabel)
            contentView.addSubview(expensePriceLabel)
            contentView.addSubview(expenseLeftPriceLabel)
            contentView.addSubview(progressView)
            
            expenseNameLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.top.equalTo(previousView.snp.bottom).offset(20)
                make.height.equalTo(20)
                make.width.equalTo(250)
            }
            
            expensePriceLabel.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(20)
                make.trailing.equalToSuperview().offset(-10)
                make.height.equalTo(20)
            }
            
            progressView.snp.makeConstraints { make in
                make.top.equalTo(expenseNameLabel.snp.bottom).offset(10)
                make.height.equalTo(5)
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalTo(expenseLeftPriceLabel.snp.leading).offset(-10)
            }
            
            expenseLeftPriceLabel.snp.makeConstraints { make in
                make.centerY.equalTo(expenseNameLabel.snp.bottom).offset(10)
                make.trailing.equalToSuperview().offset(-10)
                make.width.equalTo(60)
            }
            
            previousView = progressView
        }
    }
    
    
    private func configure() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        contentView.layer.cornerRadius = 10
        
        addSubview(imageContainer)
        addSubview(nameLabel)
        imageContainer.addSubview(image)
        
        imageContainer.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        image.snp.makeConstraints { make in
            make.center.equalTo(imageContainer.snp.center)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageContainer.snp.trailing).offset(10)
            make.centerY.equalTo(imageContainer.snp.centerY)
            make.height.equalTo(30)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
