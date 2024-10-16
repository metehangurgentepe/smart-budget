//
//  SaveButton.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 16.10.2024.
//

import Foundation
import UIKit


class SaveButton: UIButton {
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
