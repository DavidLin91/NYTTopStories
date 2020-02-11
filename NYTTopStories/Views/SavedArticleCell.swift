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
    
    private var isShowingImage = false
    
    
    private lazy var longPressedGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(didLongPress(_:)))
        return gesture
    }()
    
    
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
        label.alpha = 1
        return label
    }()
    
    
    public lazy var newImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo")
        iv.clipsToBounds = true   // keeps image within the frame
        iv.alpha = 0
        return iv
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
        addGestureRecognizer(longPressedGesture)
        setupImageViewConstraints()
    }
    
    @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let currentArticle = currentArticle else { return }
        if gesture.state == .began || gesture.state == .changed {
            print("long pressed")
            return
        }
        
        isShowingImage.toggle() // true -> false -> true
        
        newImageView.getImage(with: currentArticle.getArticleImageURL(for: .normal)) { [weak self] (result) in
            switch result {
            case .failure:
                break
            case .success(let image):
                DispatchQueue.main.async {
                    self?.newImageView.image = image
                    self?.animate()
                }
            }
        }
        
    }
    
    private func animate() {
        let duration: Double = 1.0 // seconds
        if isShowingImage {
            UIView.transition(with: self, duration: duration, options: [.transitionFlipFromRight], animations: {
                self.newImageView.alpha = 1.0
                self.articleTitle .alpha = 0.0
            }, completion: nil)
        } else {
                UIView.transition(with: self, duration: duration, options: [.transitionFlipFromLeft], animations: {
                    self.newImageView.alpha = 0.0
                    self.articleTitle .alpha = 1.0
                }, completion: nil)
            }
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
    
    private func setupImageViewConstraints() {
        addSubview(newImageView)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            newImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
    
    
    
    public func configureCell(for savedArticle: Article) {
        currentArticle = savedArticle // associated the cell with its article
        articleTitle.text = savedArticle.title
    }
    
    
    
    
    
    
}

