//
//  ViewController.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 9.03.2024.
//

import UIKit
import SnapKit


protocol MonthButtonDelegate: AnyObject {
    func selectedMonth(_ date: String)
}


class HomeVC: DataLoadingVC, AddExpenseDelegate, HeaderViewDelegate {
    
    
    
    enum Section {
        case main
    }
    
    private lazy var expenseView = ExpenseView()
    private lazy var monthButton: UIButton = {
        let button = UIButton(type: .system)
        let date = Date()
        button.setTitle("\(date.formatDate()!) ▼", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.addTarget(self, action: #selector(tappedMonthButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(50)
        label.textColor = .label
        return label
    }()
    
    private lazy var plusButtonContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .blue.withAlphaComponent(0.5)
        container.layer.cornerRadius = 25
        container.clipsToBounds = true
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        container.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(130)
        }
        
        return container
    }()
    
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var expensesCount: Int = 0
    var isInitialDataLoaded = false
    var isDataLoaded = false
    var expenses: [Expense] = []
    private var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Expense>!
    var colors: [UIColor] = [.systemBlue, .systemOrange,. systemGreen, .systemGreen, .systemRed,.systemTeal,.systemGray5]
    var viewModel = HomeViewModel()
    var selectedDate: String?
    private var headerView: HeaderView?
    
    weak var delegate: MonthButtonDelegate?
    
    private var currentDate: Date = Date()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        viewModel.delegate = self
        let date = Date()
        viewModel.getExpenses(date: date.formatMonthYear())
        viewModel.getUserMonthlyBudget()
        updateDateDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedDate == nil {
            let date = Date()
            selectedDate = date.formatMonthYear()
        }
        
        viewModel.getExpenses(date: selectedDate ?? "")
        
        updateDateDisplay()
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func configure() {
        configureViewController()
        setupGestureRecognizer()
        configureCollectionView()
        configurePlusButton()
        configureDataSource()
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, expense in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCell.identifier, for: indexPath) as! ExpenseCell
            if !self.expenses.isEmpty && indexPath.item < self.expenses.count {
                let expense = self.expenses[indexPath.item]
                cell.set(expense: expense, color: self.colors[indexPath.item])
            }
            return cell
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
            
            headerView.delegate = self
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.expenseViewTapped))
            headerView.expenseView.addGestureRecognizer(tapGesture)
            headerView.expenseView.isUserInteractionEnabled = true
            self.headerView = headerView
            
            let formattedDate = self.monthFormatter.string(from: self.currentDate)
            headerView.configure(with: formattedDate, leftMoney: "Your Left Money", monthBudget: 1000, leftBudget: 500, currency: "$")
            
            return headerView
        }
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expenseViewTapped))
        expenseView.addGestureRecognizer(tapGesture)
        expenseView.isUserInteractionEnabled = true
    }
    
    @objc private func expenseViewTapped() {
        let accumulateVC = AccumulateVC()
        navigationController?.pushViewController(accumulateVC, animated: true)
    }
    
    
    private func configurePlusButton() {
        view.addSubview(plusButtonContainer)
        
        plusButtonContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y,"scroll")
        let offset = scrollView.contentOffset.y
        
        if offset > -58 {
            navigationItem.titleView = monthButton
        } else {
            navigationItem.titleView = nil
        }
    }
    
    
    @objc func plusButtonTapped() {
        let vc = AddExpenseVC()
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 250)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.register(ExpenseCell.self, forCellWithReuseIdentifier: ExpenseCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func headerView(_ headerView: HeaderView, didChangeToDate date: String) {
        viewModel.getExpenses(date: date)
    }
    
    func headerView(_ headerView: HeaderView, didSelectDate date: String) {
        tappedMonthButton()
    }
    
    func rightButtonTapped() {
        currentDate = Calendar.current.date(byAdding: .month, value: +1, to: currentDate) ?? currentDate
        updateDateDisplay()
    }
    
    func leftButtonTapped() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        updateDateDisplay()
    }
    
    private func updateDateDisplay() {
        let formattedDate = dateFormatter.string(from: currentDate)
        selectedDate = formattedDate
        headerView?.selectedMonth(monthFormatter.string(from: currentDate))
        viewModel.getExpenses(date: formattedDate)
    }
    
    func getCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }
    
    
    func updatedData(on expenses: [Expense]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Expense>()
        snapshot.appendSections([.main])
        snapshot.appendItems(expenses)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func configureLeftMoneyLabel() {
        view.addSubview(leftMoneyLabel)
        
        leftMoneyLabel.snp.makeConstraints { make in
            make.top.equalTo(monthButton.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
    }
    
    
    private func configureMonthButton() {
        view.addSubview(monthButton)
        
        monthButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    
    private func configureExpenseView() {
        view.addSubview(expenseView)
        
        expenseView.leftBudget = 100
        expenseView.monthBudget = 200
        
        expenseView.snp.makeConstraints { make in
            make.top.equalTo(leftMoneyLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(100)
        }
    }
    
    func didAddExpense() {
        let date = Date()
        viewModel.getExpenses(date: date.formatMonthYear())
    }
    
    
    @objc func tappedMonthButton() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let alertController = UIAlertController(title: NSLocalizedString("Select Month and Year", comment: ""), message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        alertController.view.addSubview(pickerView)
        
        pickerView.frame = CGRect(x: 0, y: 52, width: alertController.view.bounds.width, height: 150)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            let selectedMonth = pickerView.selectedRow(inComponent: 0) + 1
            let selectedYear = pickerView.selectedRow(inComponent: 1) + 2023
            
            let backendFormat = String(format: "%02d/%d", selectedMonth, selectedYear)
            
            let dateComponents = DateComponents(year: selectedYear, month: selectedMonth, day: 1)
            if let newDate = Calendar.current.date(from: dateComponents) {
                self.currentDate = newDate
            }
            
            let date = self.dateFrom(month: selectedMonth, year: selectedYear)
            let displayFormat = self.monthFormatter.string(from: date)
            
            self.selectedDate = backendFormat
            self.monthButton.setTitle(displayFormat, for: .normal)
            self.viewModel.getExpenses(date: backendFormat)
            self.headerView?.selectedMonth(displayFormat)
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func dateFrom(month: Int, year: Int) -> Date {
        let components = DateComponents(year: year, month: month)
        return Calendar.current.date(from: components)!
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedExpense = expenses[indexPath.item]
        let vc = ExpenseDetailVC(id: selectedExpense.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !self.expenses.isEmpty && indexPath.item < self.expenses.count {
            let numberOfExpenseCells = self.expenses[indexPath.item].expensesDetail.count
            
            let width = ScreenSize.width - 20
            
            let height: CGFloat = CGFloat(numberOfExpenseCells) * 50 + 100
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: ScreenSize.width - 20, height: 100)
        }
    }
}


extension HomeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 12
        } else {
            return 6
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row + 1)"
        } else {
            return "\(2023 + row)"
        }
    }
}


extension HomeVC: HomeViewModelDelegate {
    func handleViewModelOutput(_ output: ExpenseListViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .setLoading(let isLoading):
                if isLoading {
                    //                showLoadingView()
                } else {
                    //                dismissLoadingView()
                }
                
            case .showExpenseList(let list):
                self.expenses = list
                self.expensesCount = list.count
                self.updatedData(on: self.expenses)
                
            case .showError(let sBError):
                presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
                
            case .emptyList:
                self.expenses.removeAll()
                self.expensesCount = 0
                self.updatedData(on: [])
                
            case .reloadCollectionView(let list):
                self.expenses = list
                self.updatedData(on: list)
                self.expensesCount = self.expenses.count
                collectionView.reloadData()
                
            case .showUser(let user):
                expenseView.configure(leftBudget: 10, monthBudget: user?.salary ?? 0, currency: user!.currency.rawValue)
                leftMoneyLabel.text = "\(user!.currency.rawValue) \(user!.salary ?? 0)"
            }
        }
    }
    
    func navigate(to navigationType: NavigationType) {
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            switch navigationType {
            case .details(let index):
                let expense = expenses[index]
                let vc = ExpenseDetailVC(id: expense.id)
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .goToVC(let vc):
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .present(let vc):
                self.present(vc,animated:true)
            }
        }
    }
}

//#Preview {
//    HomeVC()
//}

