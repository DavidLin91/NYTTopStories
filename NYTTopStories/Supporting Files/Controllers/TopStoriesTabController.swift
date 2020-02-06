//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by David Lin on 2/6/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class TopStoriesTabController: UITabBarController {

    private lazy var newsFeedVC: NewsFeedVC = {
        let viewcontroller = NewsFeedVC()
        viewcontroller.tabBarItem  = UITabBarItem(title: "News Feed", image: UIImage(systemName: "eyeglasses"), tag: 0)
        return viewcontroller
    }()

    
    private lazy var savedArticlesVC: SavedArticleVC = {
        let viewcontroller = SavedArticleVC()
        viewcontroller.tabBarItem  = UITabBarItem(title: "Saved Articles", image: UIImage(systemName: "folder"), tag: 1)
        return viewcontroller
    }()
    
    private lazy var settingsVC: SettingsVC = {
        let viewcontroller = SettingsVC()
        viewcontroller.tabBarItem  = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        return viewcontroller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [NewsFeedVC(), SavedArticleVC(), SettingsVC()]
    }
    
    
    
}
