//
//  AddExpenseVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import UIKit

class AddExpenseVC: DataLoadingVC {
    
    private let textField = UITextField()
    private let expense1TextField = UITextField()
    private let expense1Price = UITextField()
    private let expenseLeftPrice = UITextField()
    private let howManyMonthLeft = UITextField()
    var selectedExpenseTitle: ExpenseTitle?
    weak var delegate: AddExpenseDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "add"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.isHidden = true
        return pickerView
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.isHidden = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Expense Type", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "creditcard"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Expense", for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.4)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addExpenseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let paymentLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment Date"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .date
        //        datePicker.locale = Locale(identifier: "en_GB")
        picker.calendar = .autoupdatingCurrent
        return picker
    }()
    
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "Repeat Every Month"
        label.textColor = .label
        return label
    }()
    
    private let repeatSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.addTarget(self, action: #selector(switchButtonTapped), for: .allTouchEvents)
        return switchButton
    }()
    
    var viewModel = AddExpenseViewModel()
    var repeatSwitchIsOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        expense1TextField.delegate = self
        configure()
        viewModel.delegate = self
    }
    
    
    private func configure() {
        configureExpense1TextField()
        configurePriceTextField()
        configureLeftPriceTextField()
        configureSwitchLabel()
        configureHowManyMonthLeftTextField()
        configureDatePicker()
        configureSelectButton()
        configurePickerView()
        configureApplyButton()
        configureAddButton()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func configureSwitchLabel() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        view.addSubview(stack)
        
        stack.addArrangedSubview(repeatLabel)
        stack.addArrangedSubview(repeatSwitch)
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(expenseLeftPrice.snp.leading)
            make.top.equalTo(expenseLeftPrice.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func configureHowManyMonthLeftTextField() {
        view.addSubview(howManyMonthLeft)
        
        howManyMonthLeft.placeholder = "How Many Months to Repeat"
        howManyMonthLeft.borderStyle = .roundedRect
        howManyMonthLeft.layer.borderColor = UIColor.black.cgColor
        howManyMonthLeft.keyboardType = .numberPad
        
        howManyMonthLeft.isHidden = !repeatSwitchIsOn
        
        howManyMonthLeft.snp.makeConstraints { make in
            make.leading.equalTo(repeatLabel.snp.leading)
            make.top.equalTo(repeatLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
    }
    
    
    private func configureExpense1TextField() {
        view.addSubview(expense1TextField)
        
        expense1TextField.placeholder = "Title"
        expense1TextField.borderStyle = .roundedRect
        expense1TextField.layer.borderColor = UIColor.black.cgColor
        
        expense1TextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
    }
    
    @objc func switchButtonTapped() {
        repeatSwitchIsOn.toggle()
        howManyMonthLeft.isHidden = !repeatSwitchIsOn
        howManyMonthLeft.isUserInteractionEnabled = repeatSwitchIsOn
        configureDatePicker()
        configureSelectButton()
        configureHowManyMonthLeftTextField()
    }
    
    private func configureDatePicker() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        stack.addArrangedSubview(paymentLabel)
        stack.addArrangedSubview(datePicker)
        
        
        view.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        if repeatSwitchIsOn {
            howManyMonthLeft.isUserInteractionEnabled = true
            stack.snp.makeConstraints { make in
                make.top.equalTo(repeatLabel.snp.bottom).offset(60)
            }
        } else {
            howManyMonthLeft.isUserInteractionEnabled = false
            stack.snp.makeConstraints { make in
                make.top.equalTo(repeatLabel.snp.bottom).offset(10)
            }
        }
    }
    
    
    private func configureSelectButton() {
        view.addSubview(selectButton)
        
        selectButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    
    private func configurePickerView() {
        view.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    
    @objc private func selectButtonTapped() {
        pickerView.isHidden = !pickerView.isHidden
        applyButton.isHidden = !applyButton.isHidden
        addButton.isHidden = !addButton.isHidden
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedTitle = ExpenseTitle.allCases[selectedRow].rawValue
        selectButton.setTitle(selectedTitle, for: .normal)
    }
    
    
    private func configureApplyButton() {
        view.addSubview(applyButton)
        
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func configurePriceTextField() {
        view.addSubview(expense1Price)
        
        expense1Price.placeholder = "Expense Price"
        expense1Price.borderStyle = .roundedRect
        expense1Price.layer.borderColor = UIColor.black.cgColor
        expense1Price.keyboardType = .numberPad
        
        expense1Price.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(expense1TextField.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
    }
    
    private func configureLeftPriceTextField() {
        view.addSubview(expenseLeftPrice)
        
        expenseLeftPrice.placeholder = "Expense Left Price"
        expenseLeftPrice.borderStyle = .roundedRect
        expenseLeftPrice.layer.borderColor = UIColor.black.cgColor
        expenseLeftPrice.keyboardType = .numberPad
        
        expenseLeftPrice.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(expense1Price.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @objc private func applyButtonTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedTitle = ExpenseTitle.allCases[selectedRow].rawValue
        let selectedExpenseTitle = ExpenseTitle.allCases[selectedRow]
        self.selectedExpenseTitle = selectedExpenseTitle
        let icon = ExpenseIcon.allCases[selectedRow]
        let image = UIImage(systemName: icon.rawValue)
        selectButton.setTitle(selectedTitle, for: .normal)
        selectButton.setImage(image, for: .normal)
        pickerView.isHidden = !pickerView.isHidden
        applyButton.isHidden = !applyButton.isHidden
        addButton.isHidden = !addButton.isHidden
    }
    
    @objc private func addExpenseButtonTapped() {
        guard let title = selectedExpenseTitle,
              let priceText = expense1Price.text,
              let price = Int(priceText),
              let leftPrice = Int(expenseLeftPrice.text!),
              let name = expense1TextField.text else {
            presentAlertOnMainThread(title: "Error", message: "Please fill in all fields.", buttonTitle: "Ok")
            return
        }
        
        guard price >= leftPrice else {
            presentAlertOnMainThread(title: "Error", message: SBError.totalPriceMustBeBigger.localizedDescription, buttonTitle: "Ok")
            return
        }
        
        viewModel.delegate?.handleViewModelOutput(.saveExpense)
        delegate?.didAddExpense()
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    func saveMonthYearFromDatePicker(date:Date) -> String{
        let selectedDate = datePicker.date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        let year = components.year ?? 0
        let month = components.month ?? 0
        
        return "\(month)/\(year)"
    }
}

extension AddExpenseVC: UITextFieldDelegate{
    
}

extension AddExpenseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ExpenseTitle.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ExpenseTitle.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTitle = ExpenseTitle.allCases[row]
        self.selectedExpenseTitle = selectedTitle
    }
}

extension AddExpenseVC: AddExpenseViewDelegate {
    func handleViewModelOutput(_ output: AddExpenseViewModelOutput) {
        switch output {
        case .setLoading(let isLoading):
            //            if isLoading {
            //                showLoadingView()
            //            } else {
            //                dismissLoadingView()
            //            }
            break
        case .showError(let sBError):
            presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
            
        case .saveExpense:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                Task{
                    self.viewModel.addExpense(title: self.selectedExpenseTitle!,
                                              price: Int(self.expense1Price.text!)!,
                                              name: self.expense1TextField.text!,
                                              date: self.saveMonthYearFromDatePicker(date: self.datePicker.date),
                                              leftPrice: Int(self.expenseLeftPrice.text!)!,
                                              repeatMonth: self.repeatSwitchIsOn ? Int(self.howManyMonthLeft.text!)! : 0)
                }
            }
            
        case .successSavingExpense(let isSaved):
            DispatchQueue.main.async{[weak self] in
                guard let self = self else { return }
                if isSaved{
                    self.showBanner(withMessage: "Saved Successfully", success: true)
                    self.dismiss(animated: true)
                } else {
                    self.showBanner(withMessage: "Cannot saved", success: false)
                }
            }
        }
    }
}

extension AddExpenseVC {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//#Preview {
//    AddExpenseVC()
//}
