//
//  AccountVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 2.07.2024.
//

import UIKit

class AccountVC: DataLoadingVC {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add New Budget"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let currencyTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Currency (e.g., USD)"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitleColor(.gray, for: .normal)
        button.setTitle("Select Currency", for: .normal)
        return button
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private let saveButton = SaveButton(title: "Save")
    
    private var selectedCurrency: Currency?
    let viewModel = AccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, amountTextField, menuButton, currencyTextField, startDatePicker, endDatePicker, saveButton].forEach { contentView.addSubview($0) }
        
        setupConstraints()
        setupActions()
        configureMenuButtonOptions()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(44)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(50)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(20)
            make.leading.equalTo(contentView).inset(20)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.top.equalTo(startDatePicker)
            make.trailing.equalTo(contentView).inset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(startDatePicker.snp.bottom).offset(40)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    private func configureMenuButtonOptions() {
        var menuActions = [UIAction]()
        for currency in Currency.allCases {
            let action = UIAction(
                title: "\(currency.rawValue) \(currency.flag)",
                image: UIImage(named: currency.imageName)
            ) { [weak self] _ in
                self?.menuButton.setTitle("\(currency.rawValue) \(currency.flag)", for: .normal)
                self?.selectedCurrency = currency
            }
            menuActions.append(action)
        }
        
        let menu = UIMenu(title: "Select Currency", children: menuActions)
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveBudget), for: .touchUpInside)
    }
    
    @objc private func saveBudget() {
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              let currency = selectedCurrency else {
            showAlert(message: "Please enter valid amount and select a currency")
            return
        }
        
        guard startDatePicker.date < endDatePicker.date else {
            showAlert(message: "End date must be bigger than start date")
            return
        }
        
        if viewModel.validateInput(amount: amountText, currency: currency, startDate: startDatePicker.date, endDate: endDatePicker.date) {
            viewModel.saveBudget(amount: amount, currency: currency, startDate: startDatePicker.date, endDate: endDatePicker.date)
        } else {
            showAlert(message: "Please check your input")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension AccountVC: AccountViewModelDelegate {
    func handleViewModelOutput(_ output: AccountViewModelOutput) {
        DispatchQueue.main.async{ [weak self] in
            guard let self else { return }
            switch output {
            case .setLoading(let bool):
                if bool {
                    self.showLoadingView()
                } else {
                    self.dismissLoadingView()
                }
            case .showError(let sBError):
                presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
                
            case .saveSalary:
                self.dismiss(animated: true)
                
            case .didSaveBudget(let bool):
                if bool {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
