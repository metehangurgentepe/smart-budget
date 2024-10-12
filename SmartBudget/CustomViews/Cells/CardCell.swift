//
//  CardCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import UIKit

class CardCell: UITableViewCell {
    static let identifier = "CardCell"
    
    let image = UIImageView()
    
    let imageContainer = UIView()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(22)
        label.textColor = .label
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(expense: Expense, color: UIColor) {
       
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
//        print("expense: \(expense)")
        
        for expenseDetail in expense.expensesDetail {
            let expenseNameLabel: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .headline).withSize(19)
                return label
            }()
            let expensePriceLabel: UILabel = {
                let label = UILabel()
                label.font = .preferredFont(forTextStyle: .headline).withSize(19)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
