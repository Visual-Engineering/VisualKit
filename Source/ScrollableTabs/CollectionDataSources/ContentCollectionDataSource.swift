//
//  ContentCollectionDataSource.swift
//  Pods
//
//  Created by Jordi Serra on 22/5/17.
//
//

import Foundation

class ScrollableTabsContentViewCell: UICollectionViewCell {
    
    static var reuseIdentifier = "ScrollableTabsContentViewCell"
    
    var childViewController: UIViewController? {
        didSet {
            guard let vc = childViewController else { return }
            contentView.addSubview(vc.view)
            setupConstraints()
        }
    }
    
    func addChildViewController(from parentViewController: UIViewController) {
        guard let contentViewController = childViewController else { return }
        parentViewController.addChildViewController(contentViewController)
        contentViewController.didMove(toParentViewController: parentViewController)
        contentView.addSubview(contentViewController.view)
        setupConstraints()
    }
    
    func removeChildViewController() {
        guard let contentViewController = childViewController else { return }
        contentViewController.view.removeFromSuperview()
        contentViewController.willMove(toParentViewController: nil)
        contentViewController.removeFromParentViewController()
    }
    
    func setupConstraints() {
        guard let view = childViewController?.view else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

public class ContentCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    let reuseID = "ScrollableTabsContentViewCellReuseID"
    
    private unowned var collectionView: UICollectionView
    private unowned var tabConfigurator: TabConfiguratorType
    
    public init(collectionView: UICollectionView, tabConfigurator: TabConfiguratorType) {
        self.collectionView = collectionView
        self.tabConfigurator = tabConfigurator
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabConfigurator.numberOfTabs
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseID,
            for: indexPath) as? ScrollableTabsContentViewCell
        else {
            fatalError()
        }
        
        cell.removeChildViewController()
        cell.childViewController = tabConfigurator.viewController(atIndex: indexPath.item)
        
        return cell
    }
}
