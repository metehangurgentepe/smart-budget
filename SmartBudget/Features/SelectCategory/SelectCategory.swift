//
//  SelectCategory.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 14.10.2024.
//

import Foundation
import UIKit

protocol SelectCategoryViewDelegate: AnyObject {
    func didSelectCategory(_ category: Category, color: UIColor, categoryField: CategoryField)
}

class SelectCategory: UIViewController, SelectCategoryDelegate {
    let tableView = UITableView(frame: .zero, style: .grouped)
    var categoryFields: [CategoryField] = []
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    weak var delegate: SelectCategoryViewDelegate?
    var selectedCategory: CategoryField?
    var colors = ColorsConstants.all
    
    override func viewDidLoad() {
        configureViewController()
        setupBlurEffect()
        setupTableView()
        setupCategoryFields()
    }
    
    private func configureViewController() {
        title = "Categories"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupBlurEffect() {
        view.addSubview(blurEffect)
        
        blurEffect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCategoryFields() {
        categoryFields = CategoryConstants.all
    }
    
    func didSelectCategory(_ category: Category, color: UIColor) {
        if let categoryField = categoryFields.first(where: { $0.categories.contains(where: { $0.name == category.name }) }) {
            selectedCategory = categoryField
        }
        delegate?.didSelectCategory(category, color: color, categoryField: selectedCategory!)
        dismissView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}

extension SelectCategory {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let containerView = UIView()
        containerView.backgroundColor = colors[section]
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = categoryFields[section].name
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        headerView.addSubview(containerView)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        let iconImageView = UIImageView()
        if let firstCategory = categoryFields[section].categories.first {
            iconImageView.image = UIImage(systemName: firstCategory.icon)!.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = .white
            containerView.addSubview(iconImageView)
            
            iconImageView.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension SelectCategory: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryFields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        cell.configure(with: categoryFields[indexPath.section].categories, color: colors[indexPath.section])
        cell.backgroundColor = .clear
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryFields[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let categoriesCount = categoryFields[indexPath.section].categories.count
        let itemsPerRow = Int(tableView.frame.width / 100)
        let rows = ceil(Double(categoriesCount) / Double(itemsPerRow))
        return CGFloat(rows * 100)
    }
}
