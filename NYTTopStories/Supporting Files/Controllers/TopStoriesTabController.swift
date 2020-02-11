//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by David Lin on 2/6/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import DataPersistence

class TopStoriesTabController: UITabBarController {
    
    // in order to work with data persistence, the model "TopStory" needs to conform to equatable
    //instance gets created in main tab bar and injected in other VC
    
    // Step 1: setting up data persistence and its delegate (step 2 in NewsFeedVC)
    private var dataPersistence = DataPersistence<Article>(filename: "savedArticles.plist")
    
    
    
    private lazy var newsFeedVC: NewsFeedVC = {
        let viewController = NewsFeedVC()
        viewController.tabBarItem  = UITabBarItem(title: "News Feed", image: UIImage(systemName: "eyeglasses"), tag: 0)
        viewController.dataPersistence = dataPersistence  // inject data persistence
        return viewController
    }()
    
    
  //  Step 6:  setting up data persistence and its delegate
    
    private lazy var savedArticlesVC: SavedArticleVC = {
        let viewController = SavedArticleVC()
        viewController.tabBarItem  = UITabBarItem(title: "Saved Articles", image: UIImage(systemName: "folder"), tag: 1)
        viewController.dataPersistence = dataPersistence
        viewController.dataPersistence.delegate = viewController
        return viewController
    }()
    
    private lazy var settingsVC: SettingsVC = {
        let viewController = SettingsVC()
        viewController.tabBarItem  = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [UINavigationController(rootViewController: newsFeedVC),
                           UINavigationController(rootViewController: savedArticlesVC),
                           UINavigationController(rootViewController: settingsVC)]
        
    }
    
    
    
}
