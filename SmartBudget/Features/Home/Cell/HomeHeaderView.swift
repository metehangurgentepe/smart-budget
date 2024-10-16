//
//  HomeHeaderView.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 11.10.2024.
//

import Foundation
import UIKit

protocol HeaderViewDelegate: AnyObject {
    func headerView(_ headerView: HeaderView, didSelectDate date: String)
    func rightButtonTapped()
    func leftButtonTapped()
    func navigateToAccumulateVC()
}

class HeaderView: UICollectionReusableView, MonthButtonDelegate {
    static let reuseIdentifier = "HeaderView"
    
    lazy var monthButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .clear
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    let expenseView = ExpenseView()
    
    weak var delegate: HeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateAccumulate))
        expenseView.addGestureRecognizer(tapGesture)
        
        addSubview(expenseView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(monthButton)
        stackView.addArrangedSubview(rightButton)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        monthButton.snp.makeConstraints { make in
            make.center.equalTo(stackView)
            make.height.equalTo(stackView).multipliedBy(1)
        }
        
        expenseView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(140)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func selectedMonth(_ date: String) {
        monthButton.setTitle("\(date)", for: .normal)
    }

    func configure(with date: String, monthBudget: Int, leftBudget: Int, currency: String) {
        monthButton.setTitle(date, for: .normal)
        expenseView.configure(leftBudget: leftBudget, monthBudget: monthBudget, currency: currency)
    }
    
    @objc private func monthButtonTapped() {
        let date = Date()
        let str = date.formatToMonthYear()
        delegate?.headerView(self, didSelectDate: str)
    }
    
    @objc func backButtonTapped() {
        delegate?.leftButtonTapped()
    }
    
    @objc func rightButtonTapped() {
        delegate?.rightButtonTapped()
    }
    
    @objc func navigateAccumulate() {
        delegate?.navigateToAccumulateVC()
    }
}
