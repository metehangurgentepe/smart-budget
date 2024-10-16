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
        
        updateTabBarAppearance(for: traitCollection)
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
        self.changeSelectedTabColor()
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
    
    private func updateTabBarAppearance(for traitCollection: UITraitCollection) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        if traitCollection.userInterfaceStyle == .dark {
            appearance.backgroundColor = .black
            tabBar.tintColor = .tomato
            tabBar.unselectedItemTintColor = .lightGray
        } else {
            appearance.backgroundColor = .white
            tabBar.tintColor = .tomato
            tabBar.unselectedItemTintColor = .systemGray
        }
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.darkGray.cgColor : UIColor.lightGray.cgColor
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.2
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateTabBarAppearance(for: traitCollection)
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
