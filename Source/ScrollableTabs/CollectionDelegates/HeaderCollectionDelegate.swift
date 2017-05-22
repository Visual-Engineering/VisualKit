import UIKit

protocol ScrollableTabHeaderSelectionDelegate: class {
    func titleSelected(at index: Int)
}

class HeaderCollectionDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    private unowned var configurator: TabConfiguratorType
    private unowned var delegate: ScrollableTabHeaderSelectionDelegate
    
    private let numberOfTabs: Int

    init(configurator: TabConfiguratorType, delegate: ScrollableTabHeaderSelectionDelegate, numberOfTabs: Int) {
        self.configurator = configurator
        self.delegate = delegate
        self.numberOfTabs = numberOfTabs
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.titleSelected(at: indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: configurator.widthForHeader(at: indexPath.item),
            height: collectionView.frame.size.height
        )
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard configurator.tabsCentered else {
            return .zero
        }
        
        return UIEdgeInsets(
            top: 0,
            left: (collectionView.bounds.size.width - configurator.widthForHeader(at: 0)) / 2,
            bottom: 0,
            right: (collectionView.bounds.size.width - configurator.widthForHeader(at: numberOfTabs)) / 2
        )
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
