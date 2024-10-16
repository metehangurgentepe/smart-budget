//
//  ExpenseTableViewCell.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 12.10.2024.
//

import UIKit

struct ExpenseCellRow {
    var icon: String?
    var title: String
    var iconColor: UIColor?
}

class ExpenseTableViewCell: UITableViewCell {
    static let identifier = "ExpenseTableViewCell"
    
    private let circularView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.down.circle.fill")
        imageView.tintColor = .customGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(title)
        addSubview(circularView)
        circularView.addSubview(icon)
        
        circularView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(5)
        }
        
        icon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func set(cell: ExpenseCellRow) {
        icon.image = UIImage(systemName: cell.icon!)
        title.text = cell.title
        circularView.backgroundColor = cell.iconColor
        
        if cell.iconColor == .customGray {
            circularView.backgroundColor = .clear
            icon.tintColor = .customGray
            icon.snp.updateConstraints { make in
                make.size.equalTo(40)
            }
        } else {
            icon.tintColor = .white
        }
    }
}


