//
//  SplashVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 15.04.2024.
//

import UIKit

protocol SplashViewDelegate: AnyObject {
    func showError(_ error: Error)
    func navigate(vc: UIViewController)
//    func navigateToOnboarding()
}

class SplashVC: UIViewController {
    private lazy var icon: UIImageView = {
        let image = Images.recipe
        let view = UIImageView(image: image)
        return view
    }()
    
    var viewModel: SplashViewModelProtocol! = SplashViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        
        Task{
            await viewModel.getKeychain()
            viewModel.signIn()
        }
        self.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

}

extension SplashVC: SplashViewDelegate {
    func showError(_ error: Error) {
        
    }
    
    func navigate(vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.navigationController?.viewControllers.remove(at: 0)
        }
    }
    
    
}
