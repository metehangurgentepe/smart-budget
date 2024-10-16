//
//  ExpenseDetailVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import UIKit

class ExpenseDetailVC: DataLoadingVC, ExpenseDetailCellDelegate {
    var id: String!
    var viewModel: ExpenseDetailViewModel?
    var expense: Expense?
    var count: Int = 0
    var isUpdatingExpense: Bool = false

    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ExpenseDetailCell.self, forCellReuseIdentifier: ExpenseDetailCell.identifier)
        return tableView
    }()
    
    
    init(id: String!) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
        self.viewModel = ExpenseDetailViewModel(id: id)
        self.viewModel?.id = id
        viewModel?.getExpense()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        viewModel?.delegate = self
        viewModel?.getExpense()
        tableView.delegate = self
        tableView.dataSource = self
        
        configure()
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    
    private func configure() {
        configureTableView()
        configureSaveButton()
    }
    
    
    private func configureSaveButton() {
        let image = UIImage(systemName: "opticaldiscdrive.fill")?.withTintColor(.green)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tappedSaveButton))
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.rowHeight = 150
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func updateExpense(price: Int, note: String?, indexPath: IndexPath) {
        
    }
    
    
    @objc func tappedSaveButton() {
        viewModel?.delegate?.handleViewModelOutput(.saveExpense)
    }
    
    
    func saveTextFields(leftPrice: Int, totalPrice: Int, indexPath: IndexPath) {
//        var updatedDetail = expense?.expensesDetail[indexPath.row]
//        updatedDetail?.leftPrice = leftPrice
//        updatedDetail?.totalPrice = totalPrice
//        expense?.expensesDetail[indexPath.row] = updatedDetail!
    }
    
}

extension ExpenseDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseDetailCell.identifier, for: indexPath) as! ExpenseDetailCell
        return cell
    }
}

extension ExpenseDetailVC: ExpenseDetailViewDelegate {
    func handleViewModelOutput(_ output: ExpenseDetailViewModelOutput) {
        switch output {
        case .setLoading(let isLoading):
            if isLoading {
                showLoadingView()
            } else {
                dismissLoadingView()
            }
            
        case .showError(let sBError):
            presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
            
        case .getExpense(let expense):
            DispatchQueue.main.async{
                self.expense = expense
                self.title = expense.categoryFieldName
                self.tableView.reloadData()
            }
            
        case .saveExpense:
            guard !isUpdatingExpense else { return }
            isUpdatingExpense = true
            do {
                try viewModel?.updateExpense(id: expense!.id)
            } catch {
                
            }
        }
    }
    
    func updateExpenseResult() {
        isUpdatingExpense = false
    }
    
    
}
