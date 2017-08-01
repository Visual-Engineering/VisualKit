//
//  CollectionViewDataSource.swift
//  Pods
//
//  Created by Alba Luján on 29/5/17.
//
//

import Foundation

public class CollectionViewDataSource<Cell: ViewModelReusable>: NSObject, UICollectionViewDataSource where Cell: UICollectionViewCell {
    

    public weak var collectionView: UICollectionView?
    
    public var viewModel: [Cell.VM]?
    
    public weak var listPresenter: ListPresenter?
    
    fileprivate var emptyOrErrorView: UIView?

    public init(collectionView: UICollectionView,
                listPresenter: ListPresenter?) {
        self.collectionView = collectionView
        self.listPresenter = listPresenter
        super.init()
        
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
    }
    
    public func refreshInfo(viewModel: [Cell.VM]?) {
        self.viewModel = viewModel
        self.collectionView?.reloadData()
    }
    
    func addEmptyView() {
        guard let presenter = listPresenter else { return}
        switch presenter.emptyConfiguration {
        case .custom(let view):
            emptyOrErrorView = view
        case .default(let config):
            emptyOrErrorView = config.viewRepresentation()
        }
        guard let emptyView = self.emptyOrErrorView, let collectionView = self.collectionView else { fatalError() }
        collectionView.superview!.addSubview(emptyView)
    }
    
    func addErrorView() {
        guard let presenter = listPresenter else { return}
        switch presenter.errorConfiguration() {
        case .custom(let view):
            emptyOrErrorView = view
        case .default(let config):
            emptyOrErrorView = config.viewRepresentation()
        }
        guard let emptyView = self.emptyOrErrorView, let collectionView = self.collectionView else { fatalError() }
        collectionView.superview!.addSubview(emptyView)
    }

    //MARK:- UICollectionViewDataSource
    
    @objc public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = viewModel else {
            addErrorView()
            return 0
        }
        guard vm.count != 0 else {
            addEmptyView()
            return 0
        }
        return vm.count
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        guard let item = viewModel?[indexPath.item] else {
            fatalError()
        }
        cell.configure(for: item)
        return cell
    }
}

