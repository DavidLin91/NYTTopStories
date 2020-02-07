//
//  NewsFeedVC.swift
//  NYTTopStories
//
//  Created by David Lin on 2/6/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class NewsFeedVC: UIViewController {

    private let newsFeedView = NewsFeedView()    // setting view controller view to "NewsFeedView"
    
    override func loadView() {
        view = newsFeedView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        newsFeedView.collecitonView.delegate = self
        newsFeedView.collecitonView.dataSource = self
        
        
        // register a collection view cell for UICollectionViewDataSource
        newsFeedView.collecitonView.register(NewsCell.self, forCellWithReuseIdentifier: "articleCell")
    }
    
    private func fetchStories(for section: String = "Technology") {
        NYTopStoriesAPIClient.fetchTopStories(for: section) { (result) in
            switch result {
            case .failure(let appError):
                print("error fetching stories \(appError)")
            case .success(let articles):
                print("found \(articles.count)")
            }
        }
    }
    

}


extension NewsFeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return cell
    }
    
    
}

extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
    // return item size
    
    // itemHeight ~ 30% of height of device
    // itemWidth = 100% of width of device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size   // create a constant for the max size of screen
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.30 // ~30% of screen
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
