//
//  MainViewCell.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 24/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit


open class MainViewCell: UICollectionViewCell {
    
    static var reuseIdentifier = "MainViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        addSubview(titleLabel)
        backgroundColor = .black
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    open func configureFor(title: String) {
        titleLabel.text = title
    }
}


