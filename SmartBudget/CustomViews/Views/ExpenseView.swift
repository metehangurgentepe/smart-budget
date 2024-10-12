//
//  ExpenseView.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 29.03.2024.
//

import UIKit
import SnapKit

class ExpenseView: UIView {
    let leftToSpendLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = "Left to Spend"
        label.textColor = .systemGray
        return label
    }()
    
    let monthlyBudgetLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        label.text = "Monthly Budget"
        return label
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    let progressView = UIProgressView()
    
    let containerView = UIView()
    
    var leftBudget: Int?
    var monthBudget: Int?
    var currency: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let leftBudget = leftBudget, let monthBudget = monthBudget, let currency = currency {
            configure(leftBudget: leftBudget, monthBudget: monthBudget, currency: currency)
        } else {
//            configure(leftBudget: 100, monthBudget: 200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(leftBudget: Int, monthBudget: Int, currency: String) {
        let padding: CGFloat = 15
        addSubview(containerView)
        containerView.addSubview(leftToSpendLabel)
        containerView.addSubview(monthlyBudgetLabel)
        containerView.addSubview(leftLabel)
        containerView.addSubview(monthLabel)
        containerView.addSubview(progressView)
        
        configureProgressView(leftBudget: leftBudget, monthBudget: monthBudget, currencySign: currency)
        
        leftToSpendLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(padding)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        
        monthlyBudgetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftToSpendLabel.snp.leading)
            make.top.equalTo(leftToSpendLabel.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(monthlyBudgetLabel.snp.leading)
            make.top.equalTo(monthlyBudgetLabel.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(leftToSpendLabel.snp.leading)
            make.top.equalTo(leftLabel.snp.bottom).offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.equalTo(20)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureProgressView(leftBudget:Int, monthBudget: Int, currencySign: String) {
        let ratio: Float = Float(leftBudget) / Float(monthBudget)
        progressView.setProgress(ratio, animated: true)
        progressView.tintColor = .red
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.cornerRadius = 8.0
        
        leftLabel.text = "\(currencySign)\(leftBudget)"
        
        monthLabel.text = "\(currencySign)\(monthBudget)"
    }
}

//#Preview {
//    ExpenseView()
//}
