//
//  UIViewController+Ext.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 8.04.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async{
            let alertVC = AlertVC(message: message, title: title, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showBanner(withMessage message: String, success: Bool) {
        DispatchQueue.main.async{ [self] in
            
            let bannerView = UIView()
            bannerView.backgroundColor = success ? .systemGreen : .systemRed
            bannerView.layer.cornerRadius = 10
            view.addSubview(bannerView)
            
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            bannerView.addSubview(label)
            
            bannerView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(5)
                make.trailing.equalToSuperview().offset(-5)
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
                make.height.equalTo(50)
            }
            
            label.snp.makeConstraints { make in
                make.centerY.equalTo(bannerView.snp.centerY)
                make.centerX.equalTo(bannerView.snp.centerX)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                bannerView.removeFromSuperview()
            }
        }
        
    }
    
    func dismissAlertOnMainThread() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
