//
//  CategoryCollectionViewCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 14.10.2024.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "CategoryCollectionViewCell"
    
    // MARK: - UI Elements
    private let circularView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(circularView)
        circularView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        circularView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(circularView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
        }
    }
    
    // MARK: - Configuration
    func configure(with category: Category, color: UIColor) {
        circularView.backgroundColor = color
        iconImageView.image = UIImage(systemName: category.icon)
        nameLabel.text = category.name
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        circularView.backgroundColor = nil
    }
}
