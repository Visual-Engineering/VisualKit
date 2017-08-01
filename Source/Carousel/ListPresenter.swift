//
//  ListPresenter.swift
//  Pods
//
//  Created by Alba Luján on 29/5/17.
//
//

import Foundation

public protocol ListPresenter: class {
    var emptyConfiguration: EmptyListConfiguration { get }
    func errorConfiguration() -> ErrorListConfiguration
}

public enum EmptyListConfiguration {
    case `default`(ActionableListConfiguration)
    case custom(UIView)
}

public enum ErrorListConfiguration {
    case `default`(ActionableListConfiguration)
    case custom(UIView)
}

public struct ActionableListConfiguration {
    
    public var title: String
    
    public let view = UIView()
    
    public init(frame: CGRect, title: String) {
        view.frame = frame
        self.title = title
    }
    func viewRepresentation() -> UIView {
        
        view.backgroundColor = .black
        
        let titleLabel: UILabel = {
            let lbl = UILabel()
            lbl.text = title
            lbl.numberOfLines = 0
            lbl.textColor = .white
            return lbl
        }()
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }

}
