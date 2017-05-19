

import UIKit

protocol HeaderCellDataSource {
    var barHeight: CGFloat { get }
}

public struct BarConfiguration {
    let height: CGFloat
    let color: UIColor
    
    public init(height: CGFloat, color: UIColor) {
        self.height = height
        self.color = color
    }
    
    public static let `default` = BarConfiguration(height: 2, color: .black)
}

class ScrollableTabsHeaderViewCell: UICollectionViewCell {

    static var reuseIdentifier = "ScrollableTabsHeaderViewCell"

    var headerView: UIView!
    private let bottomBar = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(bottomBar)
        bottomBar.alpha = 0
        bottomBar.backgroundColor = .black

        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    override func prepareForReuse() {
        self.headerView.removeFromSuperview()
    }

    func configureHeader(_ headerView: UIView, barConfiguration: BarConfiguration = .default) {
        self.headerView = headerView
        contentView.addSubview(headerView)
        
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        bottomBar.heightAnchor.constraint(equalToConstant: barConfiguration.height).isActive = true
        bottomBar.backgroundColor = barConfiguration.color
    }

    override var isSelected: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseInOut,
                animations: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.bottomBar.alpha = strongSelf.isSelected ? 1 : 0
            }, completion: nil)
        }
    }
}
