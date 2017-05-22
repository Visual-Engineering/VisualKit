//
//  ViewController.swift
//  VisualKitDemo
//
//  Created by Jordi Serra on 18/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

class TitleCell: ScrollableTabsHeaderViewCell, ViewModelConfigurable {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override public func setup() {
        super.setup()
        
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .isActive = true
        titleLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
            .isActive = true
        
        configureBar()
    }
    
    func configure(for title: String) {
        titleLabel.text = title
    }
}

class ContentCell: UICollectionViewCell, ViewModelConfigurable {
    
    func configure(for color: UIColor) {
        contentView.backgroundColor = color
    }
}

class ViewController: UIViewController {
    
    let titles: [String] = [
        "Lorem", "ipsum", "dolor", "sit", "amet", "portitor Elam second"
    ]
    
    lazy var scrollableTabsView: ScrollableTabsView<TitleCell, ContentCell> = {
        return ScrollableTabsView<TitleCell, ContentCell>(tabConfigurator: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.view.addSubview(scrollableTabsView)
        scrollableTabsView.translatesAutoresizingMaskIntoConstraints = false
        scrollableTabsView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        scrollableTabsView.leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        scrollableTabsView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        scrollableTabsView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        
        scrollableTabsView.configure(for: titles.map({ ($0, UIColor.randomColor()) }))
    }
}

extension ViewController: TabConfiguratorType {
    var numberOfTabs: Int {
        return titles.count
    }
    
    var headerHeight: CGFloat {
        return 50
    }
    
    func widthForHeader(at index: Int) -> CGFloat {
        return 100
    }
}

extension UIColor {
    public static func randomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}


