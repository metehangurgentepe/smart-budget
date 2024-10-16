//
//  CategoryExpensesVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.10.2024.
//

import UIKit
import SnapKit

class CategoryExpensesViewController: UIViewController, UIGestureRecognizerDelegate {
    private let categoryField: CategoryField
    private var expenses: [Expense]
    private let color: UIColor
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        return tableView
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter
    }()
    
    lazy var headerView: UIView = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(30)
        title.text = self.categoryField.name
        
        let date = UILabel()
        date.font = UIFont.preferredFont(forTextStyle: .headline)
        date.text = expenses.first?.dateTime.toFormattedDateString()?.uppercased()
        
        let sv = UIStackView(arrangedSubviews: [title,date])
        sv.axis = .vertical
        sv.spacing = 10
        sv.alignment = .leading
        return sv
    }()
    
    init(categoryField: CategoryField, expenses: [Expense], color: UIColor) {
        self.categoryField = categoryField
        self.expenses = expenses
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeader()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .customGray
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupHeader() {
        let bgView = UIView()
        bgView.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(bgView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(100)
        }
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(headerView.snp.bottom)
        }
        view.bringSubviewToFront(headerView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            fatalError("Failed to dequeue CategoryCell")
        }
        
        let expense = expenses[indexPath.row]
        cell.configure(with: expense, color: color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedExpense = expenses[indexPath.row]
        let detailVC = AddExpenseVC()
        detailVC.isEditMode = true
        detailVC.expenseToEdit = selectedExpense
        detailVC.editColor = color
        present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteExpense(at: indexPath)
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteExpense(at indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        Task {
            do {
                try await ExpenseManager.shared.deleteExpense(id: expense.id)
                DispatchQueue.main.async { [weak self] in
                    self?.expenses.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                print("Failed to delete expense: \(error)")
            }
        }
    }
}
