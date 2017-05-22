

import UIKit

protocol ScrollableTabContentSelectionDelegate: class {
    func pagingContent(to index: Int, withVelocity: CGFloat)
    func scrollingContent(with offset: CGPoint, isDragging: Bool)
}

class ContentCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private weak var delegate: ScrollableTabContentSelectionDelegate?

    private var isDragging: Bool = false

    init(delegate: ScrollableTabContentSelectionDelegate) {
        self.delegate = delegate
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
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

    // MARK: - UIScrollView Events

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = targetContentOffset.pointee
        let pageWidth = scrollView.bounds.size.width
        let scrollingToPage = Int(((offset.x) + pageWidth/2) / pageWidth)
        delegate?.pagingContent(to: scrollingToPage, withVelocity: abs(velocity.x))
        isDragging = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollingContent(with: scrollView.contentOffset, isDragging: isDragging)
    }
}
