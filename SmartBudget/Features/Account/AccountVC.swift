//
//  AccountVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 2.07.2024.
//

import UIKit

class AccountVC: UIViewController {
    var salaryTextField = UITextField()
    let menuButton = UIButton()
    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    lazy var button: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.target = self
        button.action = #selector(saveButtonTapped)
        button.title = "Save"
        return button
    }()
    
    lazy var viewModel = AccountViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    func configure() {
        configureMenuButton()
        configureSalaryTextField()
        configureMenuButtonOptions()
        configureSaveButton()
    }
    
    
    @objc func saveButtonTapped() {
        Task{
            let selectedCurrency = Currency(rawValue: String(menuButton.currentTitle!.split(separator: " ")[0])) ?? .dolar
            try await viewModel.saveSalary(salary: Int(salaryTextField.text ?? "")!, currency: selectedCurrency)
        }
    }
    
    
    func configureSaveButton() {
        navigationItem.rightBarButtonItem = button
    }
    
    
    func configureMenuButtonOptions() {
        var menuActions = [UIAction]()
        for currency in Currency.allCases {
            let action = UIAction(
                title: "\(currency.rawValue) \(currency.flag)",
                image: UIImage(named: currency.imageName)
            ) { _ in
                self.menuButton.setTitle("\(currency.rawValue) \(currency.flag)", for: .normal)
            }
            menuActions.append(action)
        }
        
        let menu = UIMenu(title: "Select Currency", children: menuActions)
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    
    func configureSalaryTextField() {
        salaryTextField.placeholder = "Salary for Month"
        salaryTextField.borderStyle = .roundedRect
        salaryTextField.layer.borderColor = UIColor.black.cgColor
        salaryTextField.keyboardType = .numberPad
        salaryTextField.layer.cornerRadius = 10
        salaryTextField.layer.borderWidth = 1.0
        salaryTextField.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(salaryTextField)
        
        salaryTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(menuButton.snp.leading).offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
        }
    }
    
    
    func configureMenuButton() {
        menuButton.layer.cornerRadius = 10
        menuButton.layer.borderWidth = 1.0
        menuButton.layer.borderColor = UIColor.gray.cgColor
        menuButton.setTitleColor(.gray, for: .normal)
        menuButton.setTitle("Select Currency", for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        
        view.addSubview(menuButton)
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
    }
}
