//
//  CarouselCustomView.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 29/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation
import UIKit

public class CarouselCustomView: UIView {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .white
        return lbl
    }()
    
    public init(frame: CGRect, title: String){
        super.init(frame: frame)
        self.titleLabel.text = title
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.backgroundColor = .purple
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


