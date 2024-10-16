//
//  BottomSheetViewController.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 15.10.2024.
//

import Foundation
import UIKit

class BottomSheetViewController: UIViewController {
    let contentView = UIView()
    let handleView = UIView()
    
    var bottomSheetHeight: CGFloat = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        let blurView = UIView()
        blurView.backgroundColor = .black.withAlphaComponent(0.3)
        view.addSubview(blurView)
        blurView.frame = view.bounds
        
        view.addSubview(contentView)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.clipsToBounds = true
        
        contentView.addSubview(handleView)
        handleView.backgroundColor = .systemGray3
        handleView.layer.cornerRadius = 2.5
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(bottomSheetHeight)
        }
        
        handleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(5)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        contentView.addGestureRecognizer(panGesture)
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        blurView.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = bottomSheetHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < bottomSheetHeight {
                contentView.snp.updateConstraints { make in
                    make.height.equalTo(newHeight)
                }
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < bottomSheetHeight - 100 && isDraggingDown {
                dismissBottomSheet()
            } else {
                contentView.snp.updateConstraints { make in
                    make.height.equalTo(bottomSheetHeight)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    @objc func dismissBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func showBottomSheet() {
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }
}
