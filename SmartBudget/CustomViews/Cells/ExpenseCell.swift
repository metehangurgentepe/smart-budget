//
//  ExpenseCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 22.04.2024.
//

import UIKit

class ExpenseCell: UICollectionViewCell {
    static let identifier = "ExpenseCell"
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let expensesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForReuse()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryNameLabel.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
        
        expensesStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func setupViews() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(categoryNameLabel)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.addSubview(expensesStackView)
        
        categoryNameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        iconContainer.snp.makeConstraints { make in
            make.centerY.equalTo(categoryNameLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        expensesStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func configure(with categoryField: CategoryField, expenses: [Expense], color: UIColor) {
        categoryNameLabel.text = categoryField.name
        
        iconContainer.backgroundColor = color
        iconImageView.image = UIImage(systemName: expenses.first?.category.icon ?? "exclamationmark.triangle.fill")
        iconImageView.tintColor = .white
        
        expensesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let expensesToShow = expenses.prefix(3)
        for expense in expensesToShow {
            let expenseView = ExpenseItemView()
            expenseView.configure(with: expense)
            expensesStackView.addArrangedSubview(expenseView)
        }
        
        let totalPrice = expenses.reduce(0) { $0 + $1.price }
        let totalExpenseView = ExpenseItemView()
        totalExpenseView.configure(withTotal: totalPrice)
        
        if expensesToShow.count < 4 {
            expensesStackView.addArrangedSubview(totalExpenseView)
        }
        
        let cellHeight = max(100, CGFloat(expensesStackView.arrangedSubviews.count * 30 + 40))
        self.frame.size.height = cellHeight
    }
}

class ExpenseItemView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let dottedLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let shapeLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(priceLabel)
        addSubview(dottedLineView)
        addSubview(noteLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.2)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.1)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(3)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.2)
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.leading.equalTo(noteLabel.snp.trailing).offset(8)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-8)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(1)
        }
        
        setupDottedLine()
    }
    
    private func setupDottedLine() {
        shapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        dottedLineView.layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: dottedLineView.bounds.height / 2),
                                CGPoint(x: dottedLineView.bounds.width, y: dottedLineView.bounds.height / 2)])
        shapeLayer.path = path
    }
    
    func configure(with expense: Expense) {
        nameLabel.text = expense.category.name
        priceLabel.text = "\(expense.price)"
        if let note = expense.note, !note.isEmpty {
            noteLabel.text = note
            noteLabel.isHidden = false
        } else {
            noteLabel.isHidden = true
        }
        setNeedsLayout()
    }
    
    func configure(withTotal total: Int) {
        nameLabel.text = "Total"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel.text = "\(total)"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
