import UIKit

public class ScrollableTabsView<HeaderCell: ViewModelConfigurable, ContentCell: ViewModelConfigurable>: UIView where HeaderCell: UICollectionViewCell, ContentCell: UICollectionViewCell {
    
    public var headerDataSource: HeaderCollectionDataSource<HeaderCell>! {
        didSet {
            headerCollectionView.dataSource = headerDataSource
            headerCollectionView.register(HeaderCell.self, forCellWithReuseIdentifier: headerDataSource.reuseID)
        }
    }
    public var contentDataSource: ContentCollectionDataSource<ContentCell>! {
        didSet {
            contentCollectionView.dataSource = contentDataSource
            contentCollectionView.register(ContentCell.self, forCellWithReuseIdentifier: contentDataSource.reuseID)
        }
    }
    
    public var defaultTabIndex: Int = 0

    fileprivate var headerDelegate: HeaderCollectionDelegate? {
        didSet {
            headerCollectionView.delegate = headerDelegate
            headerCollectionView.performBatchUpdates(headerCollectionView.reloadData) { _ in
                self.selectTab(at: self.defaultTabIndex, animated: false)
            }
        }
    }

    fileprivate var contentDelegate: ContentCollectionDelegate? {
        didSet {
            contentCollectionView.delegate = contentDelegate
            contentCollectionView.reloadData()
        }
    }
    
    public unowned var tabConfigurator: TabConfiguratorType

    fileprivate let headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    fileprivate let contentCollectionView: UICollectionView = {
        let contentCollectionLayout = UICollectionViewFlowLayout()
        contentCollectionLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: contentCollectionLayout
        )
        
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        return collectionView
    }()
    
    
    fileprivate var previousContentOffset = CGPoint(x: 0, y: 0)
    
    fileprivate let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public init(tabConfigurator: TabConfiguratorType) {
        self.tabConfigurator = tabConfigurator
        super.init(frame: .zero)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        
        addSubview(rootStackView)
        rootStackView.topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true
        rootStackView.leftAnchor
            .constraint(equalTo: leftAnchor)
            .isActive = true
        rootStackView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .isActive = true
        rootStackView.rightAnchor
            .constraint(equalTo: rightAnchor)
            .isActive = true
        
        rootStackView.addArrangedSubview(headerCollectionView)
        rootStackView.addArrangedSubview(contentCollectionView)
        
        headerDataSource = HeaderCollectionDataSource<HeaderCell>(collectionView: headerCollectionView)
        contentDataSource = ContentCollectionDataSource<ContentCell>(collectionView: contentCollectionView)
        
        headerDelegate = HeaderCollectionDelegate(configurator: tabConfigurator, delegate: self, numberOfTabs: headerDataSource.collectionView(headerCollectionView, numberOfItemsInSection: 0))
        contentDelegate = ContentCollectionDelegate(delegate: self)
    }

    func reloadData() {
        headerCollectionView.reloadData()
        contentCollectionView.reloadData()
    }
    
    public func configure(for tabs: [(header: HeaderCell.VM, content: ContentCell.VM)]) {
        
        headerDataSource.configure(for: tabs.map({ $0.header }))
        contentDataSource.configure(for: tabs.map({ $0.content }))
        
        headerCollectionView.heightAnchor
            .constraint(equalToConstant: tabConfigurator.headerHeight)
            .isActive = true
        
        reloadData()
    }
}

extension ScrollableTabsView: ScrollableTabHeaderSelectionDelegate, ScrollableTabContentSelectionDelegate {

    func selectTab(at index: Int, animated: Bool = true) {
        selectTabTitle(at: index, animated: animated)
        selectTabContent(at: index, animated: animated)
    }

    func selectTabTitle(at index: Int, animated: Bool = true) {
        headerCollectionView.selectItem(
            at: IndexPath(row: index, section: 0),
            animated: animated,
            scrollPosition: .centeredHorizontally
        )
    }

    func selectTabContent(at index: Int, animated: Bool = true) {
        let tabsContentOffset = CGPoint(
            x: bounds.size.width * CGFloat(index),
            y: contentCollectionView.contentOffset.y
        )
        contentCollectionView.setContentOffset(tabsContentOffset, animated: animated)
    }

    func titleSelected(at index: Int) {
        selectTabContent(at: index, animated: true)
    }

    func pagingContent(to index: Int, withVelocity: CGFloat) {
        selectTabTitle(at: index)
    }

    func scrollingContent(with offset: CGPoint, isDragging: Bool) {
        guard isDragging == true else { return }
        var newTitlesOffset = CGPoint(x: 0, y: offset.y)
        if offset.x - previousContentOffset.x > 0 {
            newTitlesOffset.x = headerCollectionView.contentOffset.x + 1
        } else {
            newTitlesOffset.x = headerCollectionView.contentOffset.x - 1
        }
        headerCollectionView.setContentOffset(newTitlesOffset, animated: false)
        previousContentOffset = offset
    }
}
