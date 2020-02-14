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
    
    // properties
    private let savedArticleView = SavedArticleView()
    
    // Step 4: setting up data persistence and its delegate
    public var dataPersistence: DataPersistence<Article>
    
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
    
    // initalizers
    init(_ dataPersistence: DataPersistence<Article>) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
        self.dataPersistence.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        // Step 1: registering as the delegate object (need to create an extension)
        // loads the data for what is saved in the SavedArticle cell Step 3
        cell.configureCell(for: savedArticle)
        cell.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //create a programatic segue
        let article = savedArticles[indexPath.row]
        let detailVC = ArticleDVC(dataPersistence, article: article)
        
        //TODO: using intializers as opposed to injecting properties
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    
}





// Step 5: setting up data persistence and its delegate (step 6: Top Stories tab bar controller)
// conforming to the DataPersistenceDelegate

// if item gets saved or deleted, this function gets called
extension SavedArticleVC: DataPersistenceDelegate {
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        
        fetchSavedArticles() //refreshes the articles
    }
    
    
    // gets called when item gets deleted
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        fetchSavedArticles()
    }
    
    
}




// conform to SaveArticleDelegate

extension SavedArticleVC: SavedArticleCellDelegate {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article) {
        // creates an action sheet with options
        print("didselectMOreButton: \(article.title)")
        
        // create an action sheet
        // cancel action
        // delete action
        // post MVP shareAction
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
            self.deleteArticle(article)
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    private func deleteArticle(_ article: Article) {
        guard let index = savedArticles.firstIndex(of: article) else {
            return
        }
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            print("error deleting article: \(error)")
        }
    }
}

