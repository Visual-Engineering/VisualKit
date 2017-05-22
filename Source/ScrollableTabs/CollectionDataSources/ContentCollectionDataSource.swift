//
//  ContentCollectionDataSource.swift
//  Pods
//
//  Created by Jordi Serra on 22/5/17.
//
//

import Foundation

public class ContentCollectionDataSource<ContentCell: ViewModelConfigurable>: NSObject, UICollectionViewDataSource where ContentCell: UICollectionViewCell {
    
    let reuseID = "HeaderCellReuseID"
    private var viewModel: [ContentCell.VM] = []
    private unowned var collectionView: UICollectionView
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func configure(for viewModel: [ContentCell.VM]) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? ContentCell else {
            fatalError()
        }
        cell.configure(for: viewModel[indexPath.item])
        
        return cell
    }
}
