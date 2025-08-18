//
//  TabBarController.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabBar()
        print("TabBarController loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TabBarController will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TabBarController did appear")
    }
    
    private func setupTabBar() {
        // Add any additional tab bar customization here
        tabBar.backgroundColor = UIColor.orange
        tabBar.tintColor = UIColor.systemBlue
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected tab: \(tabBarController.selectedIndex)")
    }
}
