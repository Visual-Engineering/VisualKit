//
//  CarouselViewCell.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 26/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation
import UIKit
import VisualKit

class CarouselViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension CarouselViewCell: ViewModelReusable {
    
    func configure(for viewModel: CarouselItemViewModel) {
        titleLabel.text = viewModel.title
        self.backgroundColor = viewModel.backgroundColor
    }
}
