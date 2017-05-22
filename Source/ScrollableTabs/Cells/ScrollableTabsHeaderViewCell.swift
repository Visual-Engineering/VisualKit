

import UIKit

public struct BarConfiguration {
    let height: CGFloat
    let color: UIColor
    
    public init(height: CGFloat, color: UIColor) {
        self.height = height
        self.color = color
    }
    
    public static let `default` = BarConfiguration(height: 2, color: .black)
}

open class ScrollableTabsHeaderViewCell: UICollectionViewCell {

    static var reuseIdentifier = "ScrollableTabsHeaderViewCell"

    private let bottomBar = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {
        addSubview(bottomBar)
        
        bottomBar.alpha = 0
        bottomBar.backgroundColor = .black

        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    open func configureBar(_ barConfiguration: BarConfiguration = .default) {
        bottomBar.heightAnchor.constraint(equalToConstant: barConfiguration.height).isActive = true
        bottomBar.backgroundColor = barConfiguration.color
    }

    override open var isSelected: Bool {
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
