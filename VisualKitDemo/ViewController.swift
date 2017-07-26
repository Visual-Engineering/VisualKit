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

class ContentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.randomColor()
    }
}

class ViewController: UIViewController {
    
    let titles: [String] = [
        "Lorem", "ipsum", "dolor", "sit", "amet", "portitor Elam second"
    ]
    
    var viewControllers: [ContentViewController]!
    
    lazy var scrollableTabsView: ScrollableTabsView<TitleCell> = {
        return ScrollableTabsView<TitleCell>(tabConfigurator: self, parentViewController: self)
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
        
        scrollableTabsView.configure(for: titles)
        
        viewControllers = (0..<titles.count).map { _ in
            return ContentViewController()
        }
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
    
    func viewController(atIndex index: Int) -> UIViewController {
        return viewControllers[index]
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


