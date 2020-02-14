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
    private var dataPersistence: DataPersistence<Article>
    
    // data for collection view
    private var newsArticles = [Article]() {
        didSet{
            DispatchQueue.main.async {
                self.newsFeedView.collecitonView.reloadData()
            }
        }
    }
    
    // default value for sectionName
    private var sectionName = "Technology"
    
    
    // initializers
    init(_ dataPersistence: DataPersistence<Article>) {
        self.dataPersistence = dataPersistence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //setup search bar
        newsFeedView.searchBar.delegate = self
    }
    
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchStories()
    }
    
    private func fetchStories(for section: String = "Technology") {
        // retrieve section name from UserDefaults
        // typecast as? String from type Any
        if let sectionName = UserDefaults.standard.object(forKey: UserKey.sectionName) as? String {
            if sectionName != self.sectionName {    // if business == business, do not execute if
                // we are looking at a new section
                // make a new query
                queryAPI(for: sectionName)
                self.sectionName = sectionName
            } else {
                queryAPI(for: sectionName)
            }
        } else {
            // use the default section name
            queryAPI(for: sectionName)
            
        }
    }
    
    private func queryAPI(for section: String) {
        NYTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                print("error fetching stories \(appError)")
            case .success(let articles):
                self?.newsArticles = articles
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
        let articleDVC = ArticleDVC(dataPersistence, article: article)
        //TODO: After assessment, we will be using initializers as dependency injection mechanism

        
        // segues and pushes to next view (make sure to add navigation controller to array in main Collection view controller)
        navigationController?.pushViewController(articleDVC, animated: true)
    }
    
    func scrollViewDidScroll(_scrollView: UIScrollView) {
        if newsFeedView.searchBar.isFirstResponder {
            newsFeedView.searchBar.resignFirstResponder()
        }
    }
}


extension NewsFeedVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            // if text is empty, reload all the articles
            fetchStories()
            return
        }
        // filter articles based on searchText
        newsArticles = newsArticles.filter{ $0.title.lowercased().contains(searchText.lowercased())
            
        }
    }
}
