//
//  MainCollectionViewController.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 24/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

class MainCollectionViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.register(MainViewCell.self, forCellWithReuseIdentifier: "MainViewCell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        self.title = "Select a component"
        self.navigationController?.navigationBar.isTranslucent = false
            
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: collectionView.frame.size.width, height: 80)
    }
}

extension MainCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MainViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        
        switch indexPath.item {
        case 0:
            cell.configureFor(title: "Scrollable tabs")
        case 1:
            cell.configureFor(title: "Pull to refresh")
        case 2:
            cell.configureFor(title: "Carousel")
        case 3:
            cell.configureFor(title: "Rate")
        default:
            fatalError()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        switch indexPath.item {
        case 0:
            let vc = ViewController()
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        case 1:
            let vc = PullToRefreshViewController()
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        case 2:
            let vc = CarouselDifferentCasesViewController()
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        case 3:
            let vc = RateViewController()
            if let navigator = navigationController {
                navigator.pushViewController(vc, animated: true)
            }
        default:
            fatalError()
        }
    }
}


