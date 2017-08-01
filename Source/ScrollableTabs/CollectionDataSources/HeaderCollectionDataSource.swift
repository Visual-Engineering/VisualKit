//
//  HeaderCollectionDataSource.swift
//  Pods
//
//  Created by Jordi Serra on 22/5/17.
//
//

import Foundation

public class HeaderCollectionDataSource<HeaderCell: ViewModelConfigurable>: NSObject, UICollectionViewDataSource where HeaderCell: UICollectionViewCell {
    
    let reuseID = "HeaderCellReuseID"
    private var viewModel: [HeaderCell.VM] = []
    private unowned var collectionView: UICollectionView
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func configure(for viewModel: [HeaderCell.VM]) {
        self.viewModel = viewModel
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? HeaderCell else {
            fatalError()
        }
        cell.configure(for: viewModel[indexPath.item])
        
        return cell
    }
}
