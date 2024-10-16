//
//  ExpenseNoteCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 14.10.2024.
//

import UIKit

protocol ExpenseNoteCellDelegate: AnyObject {
    func didUpdateExpenseNote(_ note: String)
}

class ExpenseNoteCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "ExpenseNoteCell"
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.down.circle.fill")
        imageView.tintColor = .customGray
        imageView.image = UIImage(systemName: "note.text")
        return imageView
    }()
    
    let textField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Note"
        tf.textColor = .label.withAlphaComponent(0.8)
        tf.tintColor = .tomato
        return tf
    }()
    
    weak var delegate: ExpenseNoteCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textField.delegate = self
        addSubview(icon)
        addSubview(textField)
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.didUpdateExpenseNote(text)
    }
}
