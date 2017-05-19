//
//  ViewController.swift
//  VisualKitDemo
//
//  Created by Jordi Serra on 18/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

class ViewController: UIViewController {
    
    let titles: [String] = [
        "Lorem", "ipsum", "dolor", "sit", "amet", "portitor Elam second"
    ]
    
    lazy var scrollableTabsView: ScrollableTabsView = {
        let tabsView = ScrollableTabsView()
        return tabsView
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
//        scrollableTabsView.bottomAnchor
//            .constraint(equalTo: view.bottomAnchor)
//            .isActive = true
        scrollableTabsView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        scrollableTabsView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        scrollableTabsView.configure(dataSource: self)
    }
}


extension ViewController: ScrollableTabsDataSource {

    func numberOfTabs() -> Int {
        return titles.count
    }
    
    func headerView(at index: Int) -> UIView {
        let view = TitleView()
        view.configure(for: titles[index])
        return view
    }
    
    func contentView(at index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.randomColor()
        return view
    }
    
    func widthForHeader(at index: Int) -> CGFloat {
        if index == 0 {
            return 50
        }
        return 150
    }
    
    func headerHeight() -> CGFloat {
        return 56
    }
    
    var barConfiguration: BarConfiguration {
        return BarConfiguration(height: 2.0, color: .blue)
    }
    
    var tabsCentered: Bool {
        return false
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


private class TitleView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(titleLabel)
        
        titleLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .isActive = true
        titleLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
            .isActive = true
    }
    
    fileprivate func configure(for title: String) {
        titleLabel.text = title
    }
}

