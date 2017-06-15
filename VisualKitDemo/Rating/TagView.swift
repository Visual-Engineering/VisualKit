//
//  TagContainer.swift
//  TravelApp
//
//  Created by Jordi Serra on 8/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation
import UIKit

public enum SelectionMode{
    case selectable
    case deletable
}

public protocol TagViewTapDelegate: class {
    func clickedTag(_ sender: TagView)
    func deleteTag(_ sender: TagView)
}

public class TagView: UIView {
    
    private enum Constants {
        static let margins = UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15)
        static let buttonDim: CGFloat = 18.0
    }
    
    public var isSelected: Bool = false
    
    public var text: String
    
    let tagLabel = UILabel()
    
    public weak var delegate: TagViewTapDelegate?
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        button.backgroundColor = .blue
        button.imageEdgeInsets = UIEdgeInsets(top: CGFloat(4), left: CGFloat(4), bottom: CGFloat(4), right: CGFloat(4))
        button.addTarget(self, action: #selector(deleteTag), for: .touchUpInside)
        button.layer.cornerRadius = Constants.buttonDim / 2
        button.clipsToBounds = true
        return button
    }()
    
    public init(withText text: String, isSelected: Bool, selectionMode: SelectionMode) {
        self.text = text
        super.init(frame: .zero)
        
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
        
        addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        switch selectionMode {
        case .selectable:
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedTag)))
        case .deletable:
            addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.leadingAnchor.constraint(greaterThanOrEqualTo: tagLabel.trailingAnchor, constant: 5).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: Constants.buttonDim).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: Constants.buttonDim).isActive = true
            closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
        }
  
        self.configure(forText: text, isSelected: isSelected)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        let labelSize = self.tagLabel.intrinsicContentSize
        
        let contentHeight = ceil(labelSize.height) + (Constants.margins.top + Constants.margins.bottom)
        
        let contentWidth = ceil(labelSize.width) + (Constants.margins.left + Constants.margins.right*2) + Constants.buttonDim
        
        self.layer.cornerRadius = contentHeight / 2
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func clickedTag() {
        self.delegate?.clickedTag(self)
    }
    
    func deleteTag() {
        self.delegate?.deleteTag(self)
    }
    
    func configure(forText text: String, isSelected: Bool) {
        self.isSelected = isSelected
        
        UIView.animate(withDuration: 0.2) {
            if isSelected {
                self.backgroundColor = .blue
                
                let tagLabelString = "#\(self.text)"
                self.tagLabel.attributedText = NSAttributedString(
                    string: tagLabelString,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12.0),
                        NSForegroundColorAttributeName: UIColor.white
                    ])
                
            } else {
                self.backgroundColor = .white
                
                let tagLabelString = "#\(self.text)"
                self.tagLabel.attributedText = NSAttributedString(
                    string: tagLabelString,
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 12.0),
                        NSForegroundColorAttributeName: UIColor.blue
                    ])
            }
        }
    }
}
