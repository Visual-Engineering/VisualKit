//
//  CarouselView.swift
//  Pods
//
//  Created by Alba Luján on 26/5/17.
//
//

import Foundation

protocol CellDisplayableDelegate: class {
    func willDisplayCell(_ cell: UICollectionViewCell, at indexPath: IndexPath)
}

public class CarouselView<Cell:ViewModelReusable>: UIView, ViewModelConfigurable, UICollectionViewDelegateFlowLayout where Cell:UICollectionViewCell {
    
    var collectionView: UICollectionView!
    var dataSource: CollectionViewDataSource<Cell>!
    public var listPresenter: ListPresenter?
    
    weak var cellDisplayableDelegate: CellDisplayableDelegate?
    
    public init(cellSize: CGSize) {
        super.init(frame: .zero)
        
        let layout = CarouselViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = true
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.heightAnchor
            .constraint(equalToConstant: cellSize.height)
            .isActive = true
        collectionView.widthAnchor
            .constraint(equalToConstant: cellSize.width)
            .isActive = true
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(for viewModel: [Cell.VM]?) {
        let presenter = self.listPresenter ?? self
        dataSource = CollectionViewDataSource<Cell>(collectionView: collectionView, listPresenter: presenter)
        dataSource.refreshInfo(viewModel: viewModel)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Cell
        self.cellDisplayableDelegate?.willDisplayCell(cell, at: indexPath)
    }
}


extension CarouselView: ListPresenter {
    public func errorConfiguration() -> ErrorListConfiguration {
        return ErrorListConfiguration.default(ActionableListConfiguration(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height), title: "There's been an error"))
    }

    public var emptyConfiguration: EmptyListConfiguration {
        return EmptyListConfiguration.default(ActionableListConfiguration(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height), title: "The list is empty"))
    }
}


private final class CarouselViewFlowLayout: UICollectionViewFlowLayout {
    
    /**
     * This code is pretty ugly. You should implement this in a fancier way
     * what this basically does is some code from internet that snaps the cell
     * into the starting point of the collection view, giving a sense of 'paging'
     * this is ugly, but it works, ha!
     */
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else { fatalError() }
        
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let targetRect = CGRect(origin: CGPoint(x: proposedContentOffset.x, y: 0), size: self.collectionView?.bounds.size ?? .zero)
        
        guard let attributesArray = layoutAttributesForElements(in: targetRect) else { fatalError() }
        
        let offsetAdjustment = attributesArray.reduce(CGFloat(MAXFLOAT), { (result, attributes) -> CGFloat in
            let itemOffset = attributes.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(result) {
                return itemOffset - horizontalOffset
            }
            return result
        })
        
        return CGPoint(
            x: proposedContentOffset.x + offsetAdjustment,
            y: proposedContentOffset.y
        )
    }
}

