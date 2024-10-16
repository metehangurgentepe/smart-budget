//
//  NewAddExpenseVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 12.10.2024.
//

import UIKit

class AddExpenseVC: DataLoadingVC, SelectCategoryViewDelegate, UITextFieldDelegate {
    let tableView = UITableView()
    
    let priceLabel = PriceTextField()
    
    let saveButton = SaveButton(title: "Save")
    
    lazy var cells: [ExpenseCellRow] = [
        ExpenseCellRow(icon: "archivebox.fill", title: "Category",iconColor: .lightGray),
        ExpenseCellRow(icon: "note.text", title: "Note", iconColor: .customGray),
        ExpenseCellRow(icon: "calendar", title:  formatter.string(from: Date()), iconColor: .customGray),
        ExpenseCellRow(icon: "arrow.triangle.2.circlepath", title: "Never repeat", iconColor: .customGray),
    ]
    
    private lazy var keyboardDismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.isHidden = true
        return button
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Add Expense".uppercased()
        return label
    }()
    
    let viewModel = AddExpenseViewModel()
    var selectedCategory: Category?
    var note: String?
    var selectedDate: Date?
    var selectedField: CategoryField?
    var repeatCase: RepeatInterval?
    var isEditMode: Bool = false
    var expenseToEdit: Expense?
    var editColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupUI()
        
        if isEditMode {
            configureForEditMode()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        configurePriceLabel()
        configureTableView()
        configureSaveButton()
        setupKeyboardDismissButton()
        setupKeyboardObservers()
        
        titleLabel.text = isEditMode ? "Edit Expense".uppercased() : "Add Expense".uppercased()
        saveButton.setTitle(isEditMode ? "Update" : "Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func configureForEditMode() {
        guard let expense = expenseToEdit else { return }
        
        priceLabel.text = "\(expense.price)"
        selectedCategory = expense.category
        note = expense.note
        selectedDate = formatter.date(from: expense.dateTime)
        selectedField = CategoryConstants.all.first { $0.name == expense.categoryFieldName }
        repeatCase = expense.repeatInterval
        
        cells[0] = ExpenseCellRow(icon: expense.category.icon, title: expense.category.name, iconColor: editColor)
        cells[1] = ExpenseCellRow(icon: "note.text", title: expense.note ?? "Note", iconColor: .customGray)
        cells[2] = ExpenseCellRow(icon: "calendar", title: expense.dateTime.toFormattedDateString() ?? expense.dateTime, iconColor: .customGray)
        cells[3] = ExpenseCellRow(icon: "arrow.triangle.2.circlepath", title: expense.repeatInterval?.rawValue ?? "Never repeat", iconColor: .customGray)
        
        note = expense.note
        
        tableView.reloadData()
    }
    
    private func configureNavBar() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton.snp.centerY)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
    }
    
    func setupKeyboardDismissButton() {
        view.addSubview(keyboardDismissButton)
        
        keyboardDismissButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    fileprivate func configurePriceLabel() {
        priceLabel.text = "0"
        view.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom)
            make.width.equalTo(ScreenSize.width)
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureTableView() {
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: ExpenseTableViewCell.identifier)
        tableView.register(ExpenseNoteCell.self, forCellReuseIdentifier: ExpenseNoteCell.identifier)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    func didSelectCategory(_ category: Category, color: UIColor, categoryField: CategoryField) {
        selectedCategory = category
        cells[0] = ExpenseCellRow(icon: category.icon, title: category.name, iconColor: color)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        selectedField = categoryField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        note = textField.text
        return true
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        note = textField.text
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showDatePicker() {
        let bottomSheet = BottomSheetViewController()
        bottomSheet.bottomSheetHeight = 400
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.tintColor = .tomato
        
        bottomSheet.contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.tomato, for: .normal)
        doneButton.addTarget(self, action: #selector(datePickerDoneButtonTapped), for: .touchUpInside)
        
        bottomSheet.contentView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.top).offset(-10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        showBottomSheet(bottomSheet)
    }
    
    func showCustomAlert() {
        let bottomSheet = BottomSheetViewController()
        bottomSheet.bottomSheetHeight = 300
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        bottomSheet.contentView.addSubview(picker)
        picker.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(pickerDoneButtonTapped), for: .touchUpInside)
        
        bottomSheet.contentView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(picker.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        showBottomSheet(bottomSheet)
    }
    
    private func showBottomSheet(_ bottomSheet: BottomSheetViewController) {
        bottomSheet.showBottomSheet()
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.keyboardDismissButton.snp.updateConstraints { make in
                    make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardSize.height - 8)
                }
                self.view.layoutIfNeeded()
            }
            self.keyboardDismissButton.isHidden = false
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.keyboardDismissButton.snp.updateConstraints { make in
                make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(100)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
        self.keyboardDismissButton.isHidden = true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveButtonTapped() {
        guard let selectedCategory = selectedCategory else {
            showAlert(message: "Please select a category")
            return
        }
        
        guard let price = Int(priceLabel.text?.replacingOccurrences(of: ".", with: "") ?? ""), price > 0 else {
            showAlert(message: "Please enter valid")
            return
        }
        
        let date = selectedDate ?? Date()
        
        viewModel.setCategoryField(selectedField!)
        viewModel.setCategory(selectedCategory)
        viewModel.setPrice(price)
        viewModel.setNote(note ?? "")
        viewModel.setDate(date)
        viewModel.setRepeatInterval(repeatCase ?? .never)
        
        if isEditMode {
            guard let expenseId = expenseToEdit?.id else { return }
            viewModel.updateExpense(id: expenseId)
        } else {
            viewModel.addExpense()
        }
    }
    
    @objc func datePickerDoneButtonTapped() {
        if let bottomSheet = presentedViewController as? BottomSheetViewController,
           let datePicker = bottomSheet.contentView.subviews.first as? UIDatePicker {
            let dateString = formatter.string(from: datePicker.date)
            selectedDate = datePicker.date
            cells[2] = ExpenseCellRow(icon: "calendar", title: dateString, iconColor: .customGray)
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            bottomSheet.dismissBottomSheet()
        }
    }
    
    @objc func pickerDoneButtonTapped() {
        if let bottomSheet = presentedViewController as? BottomSheetViewController,
           let picker = bottomSheet.contentView.subviews.first as? UIPickerView {
            let selectedRow = picker.selectedRow(inComponent: 0)
            let interval = RepeatInterval.allCases[selectedRow]
            self.repeatCase = interval
            self.cells[3].title = interval.rawValue
            self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            bottomSheet.dismissBottomSheet()
        }
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
}

extension AddExpenseVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RepeatInterval.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.cells[3].title = RepeatInterval.allCases[row].rawValue
        self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RepeatInterval.allCases[row].rawValue
    }
}

extension AddExpenseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0,2,3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseTableViewCell.identifier, for: indexPath) as! ExpenseTableViewCell
            cell.set(cell: cells[indexPath.row])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseNoteCell.identifier, for: indexPath) as! ExpenseNoteCell
            cell.textField.delegate = self
            cell.textField.text = note
            return cell
        default:
            return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let selectCategory = SelectCategory()
            let vc = UINavigationController(rootViewController: selectCategory)
            vc.modalPresentationStyle = .overFullScreen
            selectCategory.delegate = self
            self.present(vc,animated: true)
        case 1:
            if let cell = tableView.cellForRow(at: indexPath) as? ExpenseNoteCell {
                cell.textField.becomeFirstResponder()
            }
            
        case 2:
            showDatePicker()
            
        case 3:
            showCustomAlert()
            
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddExpenseVC: AddExpenseViewDelegate {
    func handleViewModelOutput(_ output: AddExpenseViewModelOutput) {
        DispatchQueue.main.async{ [weak self] in
            guard let self else { return }
            switch output {
            case .setLoading(let bool):
                if bool {
                    self.showLoadingView()
                } else {
                    self.dismissLoadingView()
                }
            case .showError(let error):
                self.presentAlertOnMainThread(title: "error", message: error.localizedDescription, buttonTitle: "Ok")
                
            case .successSavingExpense(let bool):
                if bool {
                    self.dismiss(animated: true)
                } else {
                    self.presentAlertOnMainThread(title: "error", message: "error.localizedDescription", buttonTitle: "Ok")
                }
            }
        }
    }
}
