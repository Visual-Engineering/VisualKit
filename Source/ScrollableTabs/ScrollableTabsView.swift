import UIKit

public class ScrollableTabsView: UIView {

    public var tabsDataSource: ScrollableTabsDataSource? {
        didSet {
            guard let dataSource = tabsDataSource else { return }
            
            headerDelegate = HeaderCollectionDelegate(
                dataSource: dataSource,
                delegate: self
            )
            
            contentDelegate = ContentCollectionDelegate(
                dataSource: dataSource,
                view: self,
                delegate: self
            )
        }
    }

    fileprivate var headerDelegate: HeaderCollectionDelegate? {
        didSet {
            headerCollectionView.delegate = headerDelegate
            headerCollectionView.dataSource = headerDelegate
            headerCollectionView.performBatchUpdates(headerCollectionView.reloadData) { (finished) in
                guard finished, let defaultTabIndex = self.tabsDataSource?.defaultTabIndex else { return }
                self.selectTab(at: defaultTabIndex, animated: false)
            }
        }
    }

    fileprivate var contentDelegate: ContentCollectionDelegate? {
        didSet {
            contentCollectionView.delegate = contentDelegate
            contentCollectionView.dataSource = contentDelegate
            contentCollectionView.reloadData()
        }
    }

    fileprivate lazy var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ScrollableTabsHeaderViewCell.self,
            forCellWithReuseIdentifier: ScrollableTabsHeaderViewCell.reuseIdentifier
        )
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
        collectionView.register(
            ScrollableTabsContentViewCell.self,
            forCellWithReuseIdentifier: ScrollableTabsContentViewCell.reuseIdentifier
        )
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }

    func reloadData() {
        headerCollectionView.reloadData()
        contentCollectionView.reloadData()
    }
    
    public func configure(dataSource: ScrollableTabsDataSource) {
        self.tabsDataSource = dataSource
        
        guard headerCollectionView.indexPathsForSelectedItems?.isEmpty == true else { return }
        
        selectTab(at: dataSource.defaultTabIndex)
        
        headerCollectionView.heightAnchor
            .constraint(equalToConstant: dataSource.headerHeight())
            .isActive = true
        
        layoutIfNeeded()
    }
    
    public func configureBar(height:CGFloat, color: UIColor) {
        
    }
}

extension ScrollableTabsView: ScrollableTabTitleSelectionDelegate, ScrollableTabContentSelectionDelegate {

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
