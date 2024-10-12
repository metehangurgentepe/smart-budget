//
//  ExpenseDetailCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 24.04.2024.
//

import UIKit

protocol ExpenseDetailCellDelegate: AnyObject {
    func saveTextFields(leftPrice: Int, totalPrice: Int, indexPath: IndexPath)
}

class ExpenseDetailCell: UITableViewCell {
    static let identifier = "ExpenseDetailCell"
    
    let leftPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let totalPriceTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let progressView = UIProgressView(progressViewStyle: .default)
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(25)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Left"
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.textColor = .systemGray
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    weak var delegate: ExpenseDetailCellDelegate?
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(leftPriceTextField)
        contentView.addSubview(totalPriceTextField)
        contentView.addSubview(progressView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(leftLabel)
        contentView.addSubview(totalLabel)
        
        leftPriceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        totalPriceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(leftPriceTextField.snp.leading)
        }
        
        leftPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(leftLabel.snp.bottom)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(ScreenSize.width / 2 - 24)
            make.height.equalTo(50)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(totalPriceTextField.snp.leading)
        }
        
        totalPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom)
            make.leading.equalTo(contentView.snp.centerX).offset(2)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(50)
        }
        
        progressView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(leftPriceTextField.snp.bottom).offset(10)
            make.height.equalTo(7)
        }
    }
    
    func configure(expenseDetail: ExpenseDetail) {
        nameLabel.text = expenseDetail.name
        
        leftPriceTextField.text = String(expenseDetail.leftPrice)
        totalPriceTextField.text = String(expenseDetail.totalPrice)
        
        let ratio: Float = Float(expenseDetail.leftPrice) / Float(expenseDetail.totalPrice)
        progressView.setProgress(ratio, animated: true)
        progressView.tintColor = .cyan
        
        print("Cell configured with: \(expenseDetail.name)")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("TextField changed: \(textField.text ?? "")")
        
        guard let indexPath = indexPath else {
            print("IndexPath is nil")
            return
        }
        
        let total = Int(totalPriceTextField.text ?? "") ?? 0
        let left = Int(leftPriceTextField.text ?? "") ?? 0
        
        print("Values: left = \(left), total = \(total)")
        
        delegate?.saveTextFields(leftPrice: left, totalPrice: total, indexPath: indexPath)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("Cell touched")
    }
}

extension ExpenseDetailCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField began editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField ended editing")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("TextField should change characters")
        return true
    }
}
