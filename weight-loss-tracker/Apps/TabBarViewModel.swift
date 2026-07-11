//
//  TabBarViewModel.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 07/07/26.
//

import UIKit

final class TabBarViewModel {
    init() {}
    
    internal static func makeTabBar() -> UITabBarController {
        let rootVC = EntryViewController()
        let entryRootNav = UINavigationController(rootViewController: rootVC)
        entryRootNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        let historyVC = HistoryViewController()
        let historyNav = UINavigationController(rootViewController: historyVC)
        historyNav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock"),
            selectedImage: UIImage(systemName: "clock.fill")
        )
        
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gearshape")
        )
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [historyNav, entryRootNav, settingsNav]
        tabBar.selectedIndex = 1
        
        return tabBar
    }
}
