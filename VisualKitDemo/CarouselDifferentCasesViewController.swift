//
//  CarouselDifferentCasesViewController.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 30/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation
import UIKit
import VisualKit

class CarouselDifferentCasesViewController: UIViewController {
    
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
        view.backgroundColor = .black
        self.title = "Select a case"
        self.navigationController?.navigationBar.isTranslucent = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
}

extension CarouselDifferentCasesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 100)
    }
}

extension CarouselDifferentCasesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MainViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        
        switch indexPath.item {
        case 0:
            cell.configureFor(title: "Success: Reduced size")
        case 1:
            cell.configureFor(title: "Success: Full size")
        case 2:
            cell.configureFor(title: "Error: The view model is nil")
        case 3:
            cell.configureFor(title: "Custom view for error: The view model is nil")
        case 4:
            cell.configureFor(title: "The list is empty")
        case 5:
            cell.configureFor(title: "Custom view for the empty list")
        default:
            fatalError()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        var vc = CarouselViewController(carouselView: CarouselView<CarouselViewCell>(type: .customCellWidth(250)))
        switch indexPath.item {
        case 0:
            vc.showingType = .success
        case 1:
            vc = CarouselViewController(carouselView:CarouselView<CarouselViewCell>(type: .fullCellSize(showPageControl: false)))
        case 2:
            vc.showingType = .errorDefault
        case 3:
            vc.showingType = .errorCustom
        case 4:
            vc.showingType = .emptyDefault
        default:
            vc.showingType = .emptyCustom
        }
        if let navigator = navigationController {
            navigator.pushViewController(vc, animated: true)
        }
    }
}
