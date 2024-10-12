//
//  TabBarVC.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabs()
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .never
        tabBar.tintColor = .green
        
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    
    private func setupTabs() {
        let home = self.createNav(
            with: LocaleKeys.Tabs.home.rawValue.locale(),
            and: SFSymbols.home,
            vc: HomeVC())
        let settings = self.createNav(
            with: LocaleKeys.Tabs.settings.rawValue.locale(),
            and: SFSymbols.settings,
            vc: SettingsVC())
        self.setViewControllers([home, settings], animated: true)
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    
    private func changeSelectedTabColor() {
        if let items = self.tabBar.items {
            for index in 0..<items.count {
                let item = items[index]
                if index == self.selectedIndex {
                    item.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .selected)
                } else {
                    item.setTitleTextAttributes([.foregroundColor: UIColor.systemGray], for: .selected)
                }
            }
        }
    }
    
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.prefersLargeTitles = false
        
        return nav
    }
}
