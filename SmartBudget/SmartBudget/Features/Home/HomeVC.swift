//
//  ViewController.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 9.03.2024.
//

import UIKit
import Charts

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureExpenseView()
    }
    
    private func configureExpenseView() {
        var expense = ExpenseView(leftBudget: 100, monthBudget: 200)
        
        expense.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(200)
        }
    }
}

