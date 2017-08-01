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

public enum CarouselType {
    case fullCellSize(showPageControl: Bool)
    case customCellWidth(CGFloat)
}

public class CarouselView<Cell:ViewModelReusable>: UIView, ViewModelConfigurable, UICollectionViewDelegateFlowLayout where Cell:UICollectionViewCell {
    
    let collectionView: UICollectionView
    var dataSource: CollectionViewDataSource<Cell>!
    public var listPresenter: ListPresenter?
    public var viewModel: [Cell.VM]? = nil
    
    fileprivate let pageControl: UIPageControl = {
        let control = UIPageControl(frame: .zero)
        control.isEnabled = true
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    fileprivate var realCurrentPage: Int {
        guard collectionView.frame.size.width > 0 else { return 0 }
        return Int(collectionView.contentOffset.x / collectionView.frame.size.width)
    }
    
    public var currentPage: Int {
        get {
            guard let vm = viewModel, vm.count > 0 else { return 0 }
            return realCurrentPage % vm.count
        }
    }
    
    weak var cellDisplayableDelegate: CellDisplayableDelegate?
    
    let type: CarouselType
    
    public convenience init(type: CarouselType) {
        switch type {
        case .fullCellSize(let isPagingEnabled):
            self.init(showPageControl: isPagingEnabled)
        case .customCellWidth(let cellWidth):
            self.init(cellWidth: cellWidth)
        }
    }
    
    private init(showPageControl: Bool){
        self.type = .fullCellSize(showPageControl: showPageControl)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        
        setup()
        
        collectionView.delegate = self
        collectionView.isPagingEnabled = true

        if showPageControl {
            setupPageControl()
        }
    }
    
    private init(cellWidth: CGFloat) {
        self.type = .customCellWidth(cellWidth)
        let layout = CarouselViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        collectionView.delegate = self
 
        setup()
    }
    
    func setup() {
        
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isDirectionalLockEnabled = true
        
        collectionView.dataSource = dataSource
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func setupPageControl() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(for viewModel: [Cell.VM]?) {
        self.viewModel = viewModel
        let presenter = self.listPresenter ?? self
        dataSource = CollectionViewDataSource<Cell>(collectionView: collectionView, listPresenter: presenter)
        dataSource.refreshInfo(viewModel: viewModel)
        pageControl.numberOfPages = (viewModel != nil) ? viewModel!.count : 0
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.cellDisplayableDelegate?.willDisplayCell(cell, at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = {
            switch self.type {
            case .customCellWidth(let cellWidth):
                return cellWidth
            case .fullCellSize:
                return collectionView.bounds.width
            }
        }()
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    public func customPagerViewDidUpdatePage() {
        pageControl.currentPage = currentPage
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.customPagerViewDidUpdatePage()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.customPagerViewDidUpdatePage()
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

