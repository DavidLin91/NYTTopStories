//
//  NewsFeedVC.swift
//  NYTTopStories
//
//  Created by David Lin on 2/6/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import DataPersistence

class NewsFeedVC: UIViewController {

    private let newsFeedView = NewsFeedView()    // setting view controller view to "NewsFeedView"
    
    
    
    // Step 2: setting up data persistence and its delegate (step 3: extension: didSelectItemAt)
    // since we need an instance passed to the ArticleDVC, we delcare a dataPersistence here
    public var dataPersistence: DataPersistence<Article>!
    
    // data for collection view
    private var newsArticles = [Article]() {
        didSet{
            DispatchQueue.main.async {
                self.newsFeedView.collecitonView.reloadData()
            }
        }
    }
    
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
        
        fetchStories()
    }
    
    private func fetchStories(for section: String = "Technology") {
        NYTopStoriesAPIClient.fetchTopStories(for: section) { (result) in
            switch result {
            case .failure(let appError):
                print("error fetching stories \(appError)")
            case .success(let articles):
                self.newsArticles = articles
            }
        }
    }
    

}

// gets data
extension NewsFeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
            fatalError("could not downcast to NewsCell")
        }
        let article = newsArticles[indexPath.row]
        cell.configureCell(with: article)
        cell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        return cell
    }
    
    
}

//delegate = action
extension NewsFeedVC: UICollectionViewDelegateFlowLayout {
    // return item size
    
    // itemHeight ~ 30% of height of device
    // itemWidth = 100% of width of device
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size   // create a constant for the max size of screen
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.20 // ~30% of screen
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = newsArticles[indexPath.row]
        let articleDVC = ArticleDVC()
        //TODO: After assessment, we will be using initializers as dependency injection mechanism
        articleDVC.article = article
        
        
        
        // Step 3: Setting up data persistence and its delegate (step 4: SavedArticleVC)
        articleDVC.dataPersistence = dataPersistence // when you're passing data from VC to DVC (to save and pass changes)
        
        // segues and pushes to next view (make sure to add navigation controller to array in main Collection view controller)
        navigationController?.pushViewController(articleDVC, animated: true)
        
        
    }
}
