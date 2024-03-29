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
        label.text = "left to spend"
        label.textColor = .systemGray3
        return label
    }()
    
    let monthlyBudgetLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray3
        label.text = "monthly budget"
        return label
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGray3
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGray3
        return label
    }()
    
    let progressView = UIProgressView()
    
    var leftBudget: Int?
    var monthBudget: Int?
    
    convenience init(leftBudget: Int, monthBudget: Int) {
        self.init(frame: .zero)
        self.leftBudget = leftBudget
        self.monthBudget = monthBudget
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(leftBudget: leftBudget!, monthBudget: monthBudget!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(leftBudget: Int, monthBudget: Int) {
        configureProgressView(leftBudget: leftBudget, monthBudget: monthBudget)
        
        leftToSpendLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        monthlyBudgetLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftToSpendLabel.snp.leading)
            make.top.equalTo(leftToSpendLabel.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(monthLabel.snp.leading)
            make.top.equalTo(monthLabel.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.leading)
            make.top.equalTo(leftLabel.snp.bottom)
            make.trailing.equalTo(monthLabel.snp.trailing)
        }
    }
    
    private func configureProgressView(leftBudget:Int, monthBudget: Int) {
        let ratio: Float = Float(leftBudget / monthBudget)
        progressView.setProgress(ratio, animated: true)
        
        leftLabel.text = "\(leftBudget)"
        
        monthLabel.text = "\(monthBudget)"
    }
    
    
    

}
