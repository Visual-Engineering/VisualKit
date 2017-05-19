
import UIKit

class ScrollableTabsContentViewCell: UICollectionViewCell {

    static var reuseIdentifier = "ScrollableTabsContentViewCell"
    
    func configure(for content: UIView) {
        contentView.addSubview(content)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}
