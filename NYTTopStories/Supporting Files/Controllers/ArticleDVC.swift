//
//  ArticleDVC.swift
//  NYTTopStories
//
//  Created by David Lin on 2/7/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import DataPersistence
import ImageKit


class ArticleDVC: UIViewController {

    public var article: Article?
    
    public var dataPersistence: DataPersistence<Article>!
    
    private let detailView = ArticleDetailVeiw()
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        updateUI()
        
        
        // adding a UIBarButtonItem to the right side of the navigation bar's title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    }
    
    
    private func updateUI() {
        guard let article = article else {
            fatalError("did not load an article")
        }
        detailView.abstractHeadline.text = article.abstract
        
        navigationItem.title = article.title
        detailView.newsImageView.getImage(with: article.getArticleImageURL(for: .superJumbo)) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.detailView.newsImageView.image = UIImage(systemName: "exclamationmark-octagon")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.detailView.newsImageView.image = image
                }
            }
        }
    }
    
    
    // saves data in documents directory when you click on bookmark
    
    @objc func saveArticleButtonPressed(_ sender: UIBarButtonItem){
        guard let article = article else { return }
        do {
            // saves to document directory
            try dataPersistence.createItem(article)
        } catch {
            print("error saving article \(error)")
        }
    }
}
