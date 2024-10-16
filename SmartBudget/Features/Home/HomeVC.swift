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
    
    
    private lazy var monthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\(Date().formatDate()!) ▼", for: .normal)
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
    
    private lazy var plusButtonContainer: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private var collectionView: UICollectionView!
    private var headerView: HeaderView?
    
    // Data
    var expenses: [Expense] = []
    var categoryFields: [CategoryField] = CategoryConstants.all
    private var dataSource: UICollectionViewDiffableDataSource<Section, CategoryField>!
    var colors = ColorsConstants.all
    private var groupedExpenses: [String: [Expense]] = [:]
    private var displayedCategories: [String] = []
    private var monthlyBudget: Int = 1000 
    private var currency: String = "$"
    
    // View Model
    var viewModel = HomeViewModel()
    
    // Other properties
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var currentDate: Date = Date()
    var selectedDate: String?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    private enum TransitionDirection {
        case left
        case right
    }
        
    weak var delegate: MonthButtonDelegate?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        viewModel.delegate = self
        viewModel.getExpenses(date: currentDate.formatToMonthYear())
        viewModel.fetchCurrentBudget(date: currentDate)
        updateDateDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getExpenses(date: currentDate.formatToMonthYear())
        updateDateDisplay()
    }
    
    // MARK: - Configuration Methods
    
    private func configure() {
        configureViewController()
        configureCollectionView()
        configurePlusButton()
        configureDataSource()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 170)
        
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
    
    private func configurePlusButton() {
        view.addSubview(plusButtonContainer)
        
        plusButtonContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CategoryField>(collectionView: collectionView) { [weak self] (collectionView, indexPath, categoryField) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCell.identifier, for: indexPath) as? ExpenseCell else {
                fatalError("Unable to dequeue ExpenseCell")
            }
            
            let categoryExpenses = self.groupedExpenses[categoryField.codingKey] ?? []
            cell.configure(with: categoryField, expenses: categoryExpenses, color: self.colors[indexPath.item])
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
            headerView.delegate = self
            
            let formattedDate = self.monthFormatter.string(from: self.currentDate)
            let totalExpenses = self.calculateTotalExpenses()
            let leftBudget = max(0, self.monthlyBudget - totalExpenses)
            
            headerView.configure(
                with: formattedDate,
                monthBudget: self.monthlyBudget,
                leftBudget: leftBudget,
                currency: self.currency
            )
            
            return headerView
        }
        
        updateSnapshot()
    }
    
    private func groupExpenses() {
        let groupedByCategoryFieldName = Dictionary(grouping: expenses, by: { $0.categoryFieldName })
        
        groupedExpenses = Dictionary(uniqueKeysWithValues: CategoryConstants.all.map { categoryField in
            let categoryExpenses = groupedByCategoryFieldName[categoryField.name] ?? []
            return (categoryField.codingKey, categoryExpenses)
        })
        
        categoryFields = CategoryConstants.all
    }
    
    // MARK: - Action Methods
    
    @objc private func plusButtonTapped() {
        let vc = AddExpenseVC()
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
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
            let currentDate = self.monthFormatter.string(from: self.currentDate)
            self.monthButton.setTitle(currentDate, for: .normal)
            self.viewModel.getExpenses(date: backendFormat)
            self.headerView?.selectedMonth(displayFormat)
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    private func updateDateDisplay() {
        let formattedDate = dateFormatter.string(from: currentDate)
        headerView?.selectedMonth(monthFormatter.string(from: currentDate))
        viewModel.getExpenses(date: currentDate.formatToMonthYear())
    }
    
    private func updateSnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CategoryField>()
        snapshot.appendSections([.main])
        
        let categoriesToShow = categoryFields.filter { field in
            let expenses = groupedExpenses[field.codingKey] ?? []
            return !expenses.isEmpty
        }
        
        displayedCategories = categoriesToShow.map { $0.codingKey }
        
        snapshot.appendItems(categoriesToShow)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func dateFrom(month: Int, year: Int) -> Date {
        let components = DateComponents(year: year, month: month)
        return Calendar.current.date(from: components)!
    }
    
    func headerView(_ headerView: HeaderView, didChangeToDate date: String) {
        viewModel.getExpenses(date: date)
    }
    
    func headerView(_ headerView: HeaderView, didSelectDate date: String) {
        tappedMonthButton()
    }
    
    func rightButtonTapped() {
        let oldDate = currentDate
        currentDate = Calendar.current.date(byAdding: .month, value: +1, to: currentDate) ?? currentDate
        updateDateDisplay()
        monthButton.setTitle(monthFormatter.string(from: currentDate), for: .normal)
        animateTransition(direction: .right, oldDate: oldDate, newDate: currentDate)
        viewModel.fetchCurrentBudget(date: currentDate)
    }
    
    func leftButtonTapped() {
        let oldDate = currentDate
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        updateDateDisplay()
        monthButton.setTitle(monthFormatter.string(from: currentDate), for: .normal)
        animateTransition(direction: .left, oldDate: oldDate, newDate: currentDate)
        viewModel.fetchCurrentBudget(date: currentDate)
    }
    
    private func animateTransition(direction: TransitionDirection, oldDate: Date, newDate: Date) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction == .right ? .fromRight : .fromLeft
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        collectionView.layer.add(transition, forKey: nil)
        
        self.viewModel.getExpenses(date: oldDate.formatToMonthYear())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + transition.duration) {
            self.viewModel.getExpenses(date: newDate.formatToMonthYear())
        }
    }
    
    func didAddExpense() {
        
    }
    
    func navigateToAccumulateVC() {
        let vc = AccumulateVC(date: currentDate.formatToMonthYear())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func calculateTotalExpenses() -> Int {
        let totalExpenses = expenses.reduce(0) { $0 + $1.price }
        return totalExpenses
    }
    
    private func updateHeaderView() {
        let formattedDate = monthFormatter.string(from: currentDate)
        let totalExpenses = calculateTotalExpenses()
        let leftBudget = max(0, monthlyBudget - totalExpenses)
        
        if let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderView {
            headerView.configure(
                with: formattedDate,
                monthBudget: monthlyBudget,
                leftBudget: leftBudget,
                currency: currency
            )
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < displayedCategories.count else { return }
        
        let selectedCategoryKey = displayedCategories[indexPath.item]
        let categoryExpenses = groupedExpenses[selectedCategoryKey] ?? []
        
        if let selectedCategoryField = categoryFields.first(where: { $0.codingKey == selectedCategoryKey }) {
            let categoryExpensesVC = CategoryExpensesViewController(categoryField: selectedCategoryField, expenses: categoryExpenses, color: colors[indexPath.item])
            navigationController?.pushViewController(categoryExpensesVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryField = categoryFields[indexPath.item]
        let expenses = groupedExpenses[categoryField.codingKey] ?? []
        let numberOfExpenses = min(expenses.count, 3)
        let cellHeight = CGFloat(numberOfExpenses * 30 + 70)
        return CGSize(width: collectionView.bounds.width - 20, height: cellHeight)
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
            return "\(2024 + row)"
        }
    }
}

// MARK: - HomeViewModelDelegate

extension HomeVC: HomeViewModelDelegate {
    func handleViewModelOutput(_ output: ExpenseListViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .setLoading(let isLoading):
                if isLoading {
                    // showLoadingView()
                } else {
                    // dismissLoadingView()
                }
                
            case .showExpenseList(let list):
                self.expenses = list
                self.groupExpenses()
                self.updateSnapshot()
                self.collectionView.reloadData()
                
            case .showError(let sBError):
                self.presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
                
            case .emptyList:
                self.expenses.removeAll()
                self.updateSnapshot()
                
            case .getBudget(let budget):
                self.currency = budget.currency
                self.monthlyBudget = Int(budget.amount)
                self.updateHeaderView()
            }
        }
    }
    
    func navigate(to navigationType: NavigationType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch navigationType {
            case .details(let index):
                let expense = self.expenses[index]
                let vc = ExpenseDetailVC(id: expense.id)
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .goToVC(let vc):
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .present(let vc):
                self.present(vc, animated: true)
            }
        }
    }
}
