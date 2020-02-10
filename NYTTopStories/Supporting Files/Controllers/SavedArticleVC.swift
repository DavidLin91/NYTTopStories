//
//  SavedArticleVC.swift
//  NYTTopStories
//
//  Created by David Lin on 2/6/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import DataPersistence

class SavedArticleVC: UIViewController {
    
    
    private let savedArticleView = SavedArticleView()
    
    // Step 4: setting up data persistence and its delegate
    public var dataPersistence: DataPersistence<Article>!
    
    // TODO: create a SavedArticleView
    // TODO: add a colleciton view to the SavedArticleVIew
    // TODO: collection view is a vertical with 2 cells per row
    // TODO: add SavedArticleView to SavedArticleViewController
    // TODO: create an array of savedArticle = [Article]
    // TODO: reload collectionv view in didSet of savedArticle array
    
    private var savedArticles = [Article]() {
        didSet {
            savedArticleView.collectionView.reloadData()
            print("there are \(savedArticles.count) articles")
            if savedArticles.isEmpty {
                // setup our empty view on the collecito view background view
                savedArticleView.collectionView.backgroundView = EmptyView(title: "Saved Articles", message: "There are currently no saved articles. Start browsing by tapping on News icon.")
                
            }else{
                // remove empty view from collection view background view
                savedArticleView.collectionView.backgroundView = nil
            }
            
            
            
        }
    }
    
    
    override func loadView() {
        view = savedArticleView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        fetchSavedArticles()
        
        // setup collectionView
        savedArticleView.collectionView.dataSource = self
        savedArticleView.collectionView.delegate = self
        
        
        // register cell
        savedArticleView.collectionView.register(SavedArticleCell.self, forCellWithReuseIdentifier: "savedArticleCell")
    }
    
    
    private func fetchSavedArticles() {
        do {
            savedArticles = try dataPersistence.loadItems()
        } catch {
            print("error fetching articles")
        }
    }
}

extension SavedArticleVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedArticleCell", for: indexPath) as? SavedArticleCell else {
            fatalError("could not downcast to SavedArticleCell")
        }
        let savedArticle = savedArticles[indexPath.row]
        cell.backgroundColor = .systemBackground
        cell.configureCell(for: savedArticle)
        return cell
    }
    
    
}


extension SavedArticleVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize: CGSize = UIScreen.main.bounds.size
        let spacingBetweenItems: CGFloat = 10
        let numberOfItems: CGFloat = 2
        let itemHeight:CGFloat = maxSize.height * 0.30
        let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1 ) * spacingBetweenItems
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}





// Step 5: setting up data persistence and its delegate (step 6: Top Stories tab bar controller)
// conforming to the DataPersistenceDelegate

// if item gets saved or deleted, this function gets called
extension SavedArticleVC: DataPersistenceDelegate {
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        print("item was saved")
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        print("item was deleted")
    }
    
    
}
