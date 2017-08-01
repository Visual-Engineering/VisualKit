//
//  Created by Jordi Serra on 8/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//


public protocol RatingViewDelegate: class {
    func clickedStar(star: Int)
}

public class RatingView: UIView {

    //MARK: Properties
    var viewModel: RatingViewModel!
    
    public weak var delegate: RatingViewDelegate?
    
    let dataSource: TagsDataSource?
    
    var emptyStar: UIImage?
    
    var fullStar: UIImage?
    
    //MARK: UI Elements
    lazy var rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let starContainer = UIView()
    
    let starStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    let tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    let tagsView = TagsView()
    
    let defaultEmptyStarImage =  UIImage(
        view: StarView(
            lineWidth: 3.0,
            size: CGSize(width: 100.0, height: 100.0),
            strokeColor: UIColor(red: 245/255, green: 200/255, blue: 5/255, alpha: 1),
            fillColor: .white
        )
    )
    
    let defaultFullStarImage =  UIImage(
        view: StarView(
            lineWidth: 3.0,
            size: CGSize(width: 100.0, height: 100.0),
            strokeColor: UIColor(red: 245/255, green: 200/255, blue: 5/255, alpha: 1),
            fillColor: UIColor(red: 245/255, green: 200/255, blue: 5/255, alpha: 1)
        )
    )
 
    public init(withDelegate delegate: RatingViewDelegate, dataSource: TagsDataSource, viewModel: RatingViewModel, emptyStar: UIImage? = nil, fullStar: UIImage? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.dataSource = dataSource
        self.emptyStar = emptyStar == nil ? defaultEmptyStarImage : emptyStar
        self.fullStar = fullStar == nil ? defaultFullStarImage : fullStar
        
        super.init(frame: .zero)
        setup()
        
        self.configureInitialViewModel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        
        backgroundColor = .white
        
        addSubview(rootStackView)
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        rootStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        rootStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        rootStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        rootStackView.addArrangedSubview(titleLabel)
        rootStackView.addArrangedSubview(descriptionLabel)
        rootStackView.addArrangedSubview(starContainer)
        rootStackView.addArrangedSubview(tagsStackView)
        
        starContainer.addSubview(starStackView)
        starContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        starStackView.centerXAnchor.constraint(equalTo: starContainer.centerXAnchor).isActive = true
        starStackView.centerYAnchor.constraint(equalTo: starContainer.centerYAnchor).isActive = true
        
        tagsStackView.addArrangedSubview(tagsView)

        tagsView.arrangeTagsCentering = true
        tagsView.setVisibleHeight(CGFloat.greatestFiniteMagnitude)
        tagsView.dataSource = dataSource


        titleLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        descriptionLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        tagsView.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)

    }

    func configureInitialViewModel() {
        
        guard let vm = self.viewModel else {
            configure(for: RatingViewModel.default(title: "default title", description: "default description"))
            return
        }
        configure(for: vm)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override var intrinsicContentSize: CGSize {
        return super.intrinsicContentSize
    }

}
extension RatingView: ViewModelConfigurable {
    public func configure(for viewModel: RatingViewModel){
        self.viewModel = viewModel

        self.titleLabel.attributedText = NSAttributedString(
            string: viewModel.title,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 18.0),
                NSForegroundColorAttributeName: UIColor.black
            ])
        
        self.descriptionLabel.attributedText = NSAttributedString(
            string: viewModel.description,
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 15.0),
                NSForegroundColorAttributeName: UIColor.black
            ])
        
        configureStars(viewModel.stars)
        
        configureTags(viewModel.tags)

    }
 
    public func configureStars(_ numStars: Int) {
        
        self.starStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
            starStackView.removeArrangedSubview(view)
        }
        (1...self.viewModel.numTotalStars).forEach { (number) in
            let starImage: UIImage = {
                if number <= numStars {
                    return fullStar!
                } else {
                    return emptyStar!
                }
            }()
            let starButton: UIButton = {
                let button = UIButton()
                button.adjustsImageWhenHighlighted = false
                button.setImage(starImage, for: .normal)
                button.imageView?.contentMode = .scaleAspectFit
                button.tag = number
                button.addTarget(self, action: #selector(clickedStar), for: .touchUpInside)
                return button
            }()
            
            starButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            self.starStackView.addArrangedSubview(starButton)
        }
    }

    public func configureTags(_ tags: [RatingViewModel.Tag]) {
        
        self.viewModel.tags = tags
        
        let texts: [String] = tags.map({ tag -> String in
            return tag.text
        })
        tagsView.configure(forTags: texts, editable: true, tagDelegate: nil)
    }

    //MARK: User Interaction
    func clickedStar(sender: UIButton) {
        guard let viewModel = self.viewModel else { fatalError() }
        
        if viewModel.stars != sender.tag {
            self.delegate?.clickedStar(star: sender.tag)
        }
    }
}

extension RatingView {
    override public func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        return tagsView.intrinsicContentSize
    }
}

extension UIImage{
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}

