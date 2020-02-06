//
//  NewFeedView.swift
//  NYTTopStories
//
//  Created by David Lin on 2/6/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit



class NewsFeedView: UIView {  // used custom code snippet /createcustom
    
    
    public lazy var searchBar: UISearchBar = {
     let sb = UISearchBar()
        sb.autocapitalizationType = .none
        sb.placeholder = ""
        return sb
    }()
    
    public lazy var collecitonView: UICollectionView = {
       // create flow layout for collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return cv
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
        setupSearchBarConstraints()
        setupCollectionViewConstraints()
    }
    
    private func setupSearchBarConstraints() {
        // Step 1 - setup (searchBar)
        addSubview(searchBar)
        
        // 2 - add autoresizing = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 3.
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor)
            // when done with constraints, call it in the commonInit
        ])
    }
    
    
    private func setupCollectionViewConstraints() {
        addSubview(collecitonView)
        collecitonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collecitonView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collecitonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collecitonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collecitonView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        
        
        ])
    }
    
    
    
}

