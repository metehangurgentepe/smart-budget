//
//  AccumulateVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import UIKit

class AccumulateVC: DataLoadingVC, AddAccumulateDelegate, UIGestureRecognizerDelegate {
    var viewModel = AccumulateViewModel()
    var accumulate: [Accumulate] = []
    var tableView: UITableView = {
        let table = UITableView()
        table.register(AccumulateCell.self, forCellReuseIdentifier: AccumulateCell.identifier)
        return table
    }()
    
    lazy var headerView: UIView = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(30)
        title.text = "Savings"
        
        let date = UILabel()
        date.font = UIFont.preferredFont(forTextStyle: .headline)
        date.text = currentDate?.toFormattedDateString()?.uppercased()
        
        let sv = UIStackView(arrangedSubviews: [title,date])
        sv.axis = .vertical
        sv.spacing = 10
        sv.alignment = .leading
        return sv
    }()
    
    var currentDate: String?
    
    init(date: String) {
        self.currentDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        view.backgroundColor = .systemBackground
        configureDesign()
        
        Task{
            viewModel.getAccumulate(date: currentDate ?? Date().formatToMonthYear())
        }
    }
    
    func didAddAccumulate() {
        Task{
            viewModel.getAccumulate(date: currentDate ?? Date().formatToMonthYear())
        }
        tableView.reloadData()
    }
    
    
    private func configureDesign() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .customGray
        navigationItem.leftBarButtonItem = backButton
        
        configureTableView()
        configurePlusButton()
        setupHeader()
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
    
    
    private func configurePlusButton() {
        let image = UIImage(systemName: "plus.circle.fill")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tappedPlusButton))
        button.tintColor = .customOrange
        navigationItem.rightBarButtonItem = button
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
    
    
    @objc func tappedPlusButton() {
        let addAccumulateVC = AddAccumulateVC()
        addAccumulateVC.delegate = self
        addAccumulateVC.modalPresentationStyle = .overFullScreen
        addAccumulateVC.modalTransitionStyle = .crossDissolve
        present(addAccumulateVC, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AccumulateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accumulate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccumulateCell.identifier, for: indexPath) as! AccumulateCell
        let accumulate = self.accumulate[indexPath.row]
        cell.set(accumulate: accumulate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = self.accumulate[indexPath.row].id
            viewModel.deleteAccumulate(id: id)
            self.accumulate.removeAll(where: {$0.id == id})
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension AccumulateVC: AccumulateViewModelDelegate {
    func handleViewModelOutput(_ output: AccumulateViewModelOutput) {
        DispatchQueue.main.async{
            switch output {
            case .setLoading(let isLoading):
                if isLoading {
                    self.showLoadingView()
                } else {
                    self.dismissLoadingView()
                }
                
            case .showAccumulateList(let array):
                self.accumulate = array
                self.tableView.reloadData()
                
            case .showError(let sBError):
                self.presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
                
            case .emptyList:
                break
                
            case .reloadCollectionView:
                self.tableView.reloadData()
            }
        }
    }
}
