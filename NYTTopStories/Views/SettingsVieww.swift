//
//  SettingsVieww.swift
//  NYTTopStories
//
//  Created by David Lin on 2/10/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class SaettingsView: UIView {
    
    public lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
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
        setupPickerViewConstraints()
    }
    
    
    private func setupPickerViewConstraints() {
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pickerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    
    
    
    
}

