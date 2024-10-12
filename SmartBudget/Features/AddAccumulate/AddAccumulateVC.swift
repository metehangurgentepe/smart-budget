//
//  AddAccumulateVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import UIKit

class AddAccumulateVC: UIViewController, UITextFieldDelegate {
    
    let containerView = AlertContainerView()
    var nameTextField = UITextField()
    var priceTextField = UITextField()
    let menuButton = UIButton()
    let actionButton = CustomButton(backgroundColor: Colors.primary.color, title: "Add")
    var viewModel = AddAccumulateViewModel()
    weak var delegate: AddAccumulateDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .secondaryLabel
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
        viewModel.delegate = self
    }
    
    private func configure() {
        configureContainerView()
        configureActionButton()
        configureNameTextField()
        configurePriceTextField()
        configureMenuButtonOptions()
        configureMenuButton()
    }
    
    func configureMenuButtonOptions() {
        var menuActions = [UIAction]()
        for currency in Currency.allCases {
            let action = UIAction(
                title: "\(currency.rawValue) \(currency.flag)",
                image: UIImage(named: currency.imageName)
            ) { _ in
                self.menuButton.setTitle("\(currency.rawValue) \(currency.flag)", for: .normal)
            }
            menuActions.append(action)
        }
        
        let menu = UIMenu(title: "Select Currency", children: menuActions)
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
    }
    
    
    func configureMenuButton() {
        menuButton.layer.cornerRadius = 10
        menuButton.layer.borderWidth = 1.0
        menuButton.layer.borderColor = UIColor.gray.cgColor
        menuButton.setTitleColor(.gray, for: .normal)
        menuButton.setTitle("Select Currency", for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        
        view.addSubview(menuButton)
        
        menuButton.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.top.equalTo(priceTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }
    
    
    func configureNameTextField() {
        nameTextField.delegate = self
        containerView.addSubview(nameTextField)
        
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.cornerRadius = 10
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(30)
        }
    }
    
    
    func configurePriceTextField() {
        priceTextField.delegate = self
        containerView.addSubview(priceTextField)
        
        priceTextField.placeholder = "Price"
        priceTextField.borderStyle = .roundedRect
        priceTextField.layer.cornerRadius = 10
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(30)
        }
    }
    
    
    func configureContainerView() {
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(200)
        }
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle( "Add", for: .normal)
        actionButton.addTarget(self, action: #selector(addAccumulate), for: .touchUpInside)
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom).offset(-10)
            make.leading.equalTo(containerView.snp.leading).offset(20)
            make.trailing.equalTo(containerView.snp.trailing).offset(-20)
            make.height.equalTo(44)
        }
    }
    
    
    @objc func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    
    @objc func addAccumulate() {
        Task{
            if let price = Int(priceTextField.text!), let selectedCurrency = Currency(rawValue: String((menuButton.currentTitle!.first!))){
                try await viewModel.saveAccumulate(name: nameTextField.text!, price: price, currency: selectedCurrency)
                delegate?.didAddAccumulate()
            } else {
                viewModel.delegate?.handleViewModelOutput(.showError(.serializationError))
            }
        }
    }
}

extension AddAccumulateVC: AddAccumulateViewModelDelegate {
    func handleViewModelOutput(_ output: AddAccumulateViewModelOutput) {
        switch output {
        case .setLoading(let bool):
            break
        case .showError(let sBError):
            presentAlertOnMainThread(title: "Error", message: sBError.localizedDescription, buttonTitle: "Ok")
            
        case .addAccumulate:
            DispatchQueue.main.async{
                self.dismiss(animated: true)
            }
            
        case .dismissContainerView:
            break
        }
    }
}
