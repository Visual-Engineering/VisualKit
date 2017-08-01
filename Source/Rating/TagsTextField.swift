//
//  TagsTextField.swift
//  TravelApp
//
//  Created by Jordi Serra on 10/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation

public protocol TagsFieldDelegate: class {
    func didCompleteTag(_ tag: String)
}

public class TagsTextField: UITextField {
    fileprivate enum Constants {
        static let insets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        static let breakChars = [ " ", ",", "."]
        static let maxChars = 15
    }
    
    public weak var tagsFieldDelegate: TagsFieldDelegate?
    
    public init() {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: 12.0)
        self.textColor = .blue
        
        self.delegate = self
        
        self.autocorrectionType = .no
        
        self.placeholder = "#..."
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return UIEdgeInsetsInsetRect(rect, Constants.insets)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, Constants.insets)
    }
}

extension TagsTextField: UITextFieldDelegate {
    
    public func tagCompleted(textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.tagsFieldDelegate?.didCompleteTag(text.replacingOccurrences(of: " ", with: ""))
        textField.text = nil
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //Cannot write longer than maxChars
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        if newLength > Constants.maxChars {
            return false
        }
        
        //If it conains a breakChar, then complete tag
        if Constants.breakChars.contains(string) {
            self.tagCompleted(textField: textField)
        }
        
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.tagCompleted(textField: textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagCompleted(textField: textField)
        return true
    }
}
