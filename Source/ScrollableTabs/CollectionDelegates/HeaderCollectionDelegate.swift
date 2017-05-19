import UIKit

protocol ScrollableTabTitleSelectionDelegate: class {
    func titleSelected(at index: Int)
}

class HeaderCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let dataSource: ScrollableTabsDataSource
    private weak var delegate: ScrollableTabTitleSelectionDelegate?

    private let titlePadding: CGFloat = 70

    init(dataSource: ScrollableTabsDataSource, delegate: ScrollableTabTitleSelectionDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfTabs()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScrollableTabsHeaderViewCell.reuseIdentifier,
            for: indexPath
            ) as? ScrollableTabsHeaderViewCell else {
                return UICollectionViewCell()
        }        
        cell.configureHeader(
            dataSource.headerView(at: indexPath.item),
            barConfiguration: dataSource.barConfiguration)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.titleSelected(at: indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: dataSource.widthForHeader(at: indexPath.item),
            height: collectionView.frame.size.height
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard dataSource.tabsCentered else {
            return .zero
        }
        
        let leftInset = (collectionView.bounds.size.width - dataSource.widthForHeader(at: 0))/2
        let rightInset = (collectionView.bounds.size.width - dataSource.widthForHeader(at: dataSource.numberOfTabs()))/2
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
