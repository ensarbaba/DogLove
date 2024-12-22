//
//  HomeTabBarController.swift
//  DogLove
//
//  Created by M. Ensar Baba on 2024-12-22.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabBar()
        prepareViewControllers()
    }

    private func prepareTabBar() {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)

        tabBar.backgroundColor = .lightGray
    }

    private func prepareViewControllers() {
        let dogSearchUIKitController = DogSearchController()
        dogSearchUIKitController.tabBarItem = UITabBarItem(
            title: "🐶 List",
            image: nil,
            tag: 0
        )
        viewControllers = [dogSearchUIKitController]
    }
}
