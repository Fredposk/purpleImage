//
//  PiTabBarController.swift
//  PurpleImage
//
//  Created by Frederico Kuckelhaus on 27.12.21.
//

import UIKit

class PiTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = .systemPurple
        UITabBar.appearance().backgroundColor = .secondarySystemBackground

        self.viewControllers = [createSearchViewController(), createFavoritesViewController()]
    }

        private func createSearchViewController() -> UINavigationController {
            let searchVC = SearchPicturesVC()
            searchVC.tabBarItem = UITabBarItem(title: "Search", image: Images.search, tag: 0)
            return UINavigationController(rootViewController: searchVC)
        }

       private func createFavoritesViewController() -> UINavigationController {
           let favouritesVC = FavoritesVC()
           favouritesVC.tabBarItem = UITabBarItem(title: "Liked", image: Images.notHeartedImage, tag: 1)
           return UINavigationController(rootViewController: favouritesVC)
        }

}
