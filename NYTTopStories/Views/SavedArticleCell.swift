//
//  SavedArticle Cell.swift
//  NYTTopStories
//
//  Created by David Lin on 2/10/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit


// Step 1: custom protocol
// create protocol
protocol SavedArticleCellDelegate: AnyObject {
    func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article)
}


class SavedArticleCell: UICollectionViewCell {
    
    
    // Step 2: custom protocol
    // create delegate to conform to delegate (step 3 happens where the action for saving occurs: @objc method)
    weak var delegate: SavedArticleCellDelegate?
    
    
    // to keep trac kof the current cell's article
    private var currentArticle: Article!
    
    
    // more button
    // article title
    // news image
    public lazy var moreButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        // add target is needed to execute function.. when person clicks taget (cell, the moreButtonPressed func gets called)
        button.addTarget(self, action: #selector(moreButtonPressed(_sender:)), for: .touchUpInside)
        return button
    }()
    
    public lazy var articleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commonInit()
    }
    
    
    private func commonInit() {
        setupMorebuttonConstraints()
        setupArticleTitleConstraints()
    }
    
    @objc private func moreButtonPressed(_sender: UIButton) {
        // Step 3: custom protocl (step 4: savedArticleVC, set the info in the cellForItemAt)
        // captures the data for the specific cell its clicked on
        delegate?.didSelectMoreButton(self, article: currentArticle)
    }
    
    
    private func setupMorebuttonConstraints() {
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor)
        
        ])
    }
    
    
    private func setupArticleTitleConstraints() {
        addSubview(articleTitle)
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            articleTitle.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
            articleTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configureCell(for savedArticle: Article) {
        currentArticle = savedArticle // associated the cell with its article
        articleTitle.text = savedArticle.title
    }
    
    
    
    
    
    
}

