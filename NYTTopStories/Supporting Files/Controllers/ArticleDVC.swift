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

    // properties
    private var articles: Article
    
    private var dataPersistence: DataPersistence<Article>!
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    
    
    
    private let detailView = ArticleDetailVeiw()
    
    
    // additon: keep trakck of bookmark
    private var bookmarkButton: UIBarButtonItem!
    
    // initializer
    init(_ dataPersistence: DataPersistence<Article>, article: Article) {
        self.dataPersistence = dataPersistence
        self.articles = article
        super.init(nibName: nil, bundle: nil)
    }
    
    // NScoding protocol requires anyone having a custon initializer to have a required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        updateUI()
        // adding a UIBarButtonItem to the right side of the navigation bar's title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
    
        detailView.newsImageView.isUserInteractionEnabled = true
        detailView.newsImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        let image = detailView.newsImageView.image ?? UIImage()
        // need an instance of ZoomImageViewController from storyboard
        let zoomImageStoryboard = UIStoryboard(name: "ZoomImage", bundle: nil)
        let zoomImageVC = zoomImageStoryboard.instantiateViewController(identifier: "ZoomImageVC") { coder in
            return ZoomImageVC(coder: coder, image: image)
        }
        present(zoomImageVC, animated: true)
    }
    
    
    private func updateUI() {
        
        detailView.abstractHeadline.text = articles.abstract
        
        navigationItem.title = articles.title
        detailView.newsImageView.getImage(with: articles.getArticleImageURL(for: .superJumbo)) { [weak self] (result) in
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
        do {
            // saves to document directory
            try dataPersistence.createItem(articles)
        } catch {
            print("error saving article \(error)")
        }
    }
}
