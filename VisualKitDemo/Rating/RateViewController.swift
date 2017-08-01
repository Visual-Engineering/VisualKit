//
//  RateViewController.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 12/6/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

public class RateViewController: UIViewController {
    
    var rate: RatingView!
    
    var viewModel: RatingViewModel!
    
    var selectionMode: SelectionMode = .deletable
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let textField: TagsTextField = {
            let field = TagsTextField()
            field.layer.borderColor = UIColor.blue.cgColor
            field.layer.borderWidth = 1
            field.layer.cornerRadius = field.intrinsicContentSize.height / 2
            return field
        }()
        
        let rootStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 20
            return stackView
        }()

        self.viewModel = RatingViewModel(
            title: "TITLE",
            description: "Description",
            stars: 0,
            numTotalStars: 8,
            tags: [RatingViewModel.Tag(fromResponse: "helloooooooo"),
                   RatingViewModel.Tag(fromResponse: "hello2")
            ])
        
        self.rate = RatingView(withDelegate: self, dataSource: self, viewModel: self.viewModel)
        textField.tagsFieldDelegate = self
        self.view.backgroundColor = .white
        
        self.view.addSubview(rootStackView)
        rootStackView.addArrangedSubview(self.rate)
        rootStackView.addArrangedSubview(textField)
        
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rootStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rootStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension RateViewController: RatingViewDelegate {
    public func clickedStar(star: Int){
        print("star \(star) has been clicked")
        self.rate.configureStars(star)
    }
}

extension RateViewController: TagsFieldDelegate {
    public func didCompleteTag(_ tag: String) {
        guard let tags = self.viewModel?.tags else { fatalError() }
        
        let filteredTags = tags.filter({ $0.text.lowercased() != tag.lowercased() })
        switch self.selectionMode {
        case .deletable:
            viewModel.tags = filteredTags + [RatingViewModel.Tag(text: tag.lowercased(), isSelected: false)]
        case .selectable:
            viewModel.tags = filteredTags + [RatingViewModel.Tag(text: tag.lowercased(), isSelected: true)]
        }
        self.rate.configureTags(viewModel.tags)
    }
}


extension RateViewController: TagsDataSource {
    public func customTagView(forTag tag: String) -> UIView {
        guard let tags = self.viewModel?.tags else { fatalError() }
        let isSelected = !(tags.filter({ $0.text.lowercased() == tag && $0.isSelected }).isEmpty)
        
        let tagView = TagView(withText: tag, isSelected: isSelected, selectionMode: self.selectionMode)
        tagView.delegate = self
        return tagView
    }
}

extension RateViewController: TagViewTapDelegate {
    public func clickedTag(_ sender: TagView) {
        guard let num = self.viewModel.tags.index(where: {$0.text == sender.text}) else {
            return
        }
        self.viewModel.tags[num].isSelected = !self.viewModel.tags[num].isSelected
        self.rate.configureTags(self.viewModel.tags)
    }
    
    public func deleteTag(_ sender: TagView) {
        guard let num = self.viewModel.tags.index(where: {$0.text == sender.text}) else {
            return
        }
        viewModel.tags.remove(at: num)
        self.rate.configureTags(self.viewModel.tags)
    }
}
