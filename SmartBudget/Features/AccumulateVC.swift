//
//  AccumulateVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import UIKit

class AccumulateVC: DataLoadingVC, AddAccumulateDelegate {
    var viewModel = AccumulateViewModel()
    var accumulate: [Accumulate] = []
    var tableView: UITableView = {
        let table = UITableView()
        table.register(AccumulateCell.self, forCellReuseIdentifier: AccumulateCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        view.backgroundColor = .systemBackground
        title = "Accumulates"
        configureDesign()
        
        Task{
            let date = Date()
            let formattedDate = date.formatToMonthYear()
            viewModel.getAccumulate(date: formattedDate)
        }
    }
    
    func didAddAccumulate() {
        Task{
            let date = Date()
            let formattedDate = date.formatToMonthYear()
            viewModel.getAccumulate(date: formattedDate)
        }
        tableView.reloadData()
    }
    
    
    private func configureDesign() {
        configureTableView()
        configurePlusButton()
    }
    
    
    private func configurePlusButton() {
        let image = UIImage(systemName: "plus.circle.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tappedPlusButton))
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
