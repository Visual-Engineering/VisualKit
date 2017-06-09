//
//  CarouselViewController.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 26/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

public enum CarouselShowType {
    case success
    case errorDefault
    case errorCustom
    case emptyDefault
    case emptyCustom
}

public struct CarouselItemViewModel {
    let title: String
    let backgroundColor: UIColor
}

public class CarouselViewController: UIViewController {

 //   lazy var carouselView = CarouselView<CarouselViewCell>(type: .fullCellSize(showPageControl: true))
    
 //   lazy var carouselView = CarouselView<CarouselViewCell>(type: .customCellWidth(250))
    
    let carouselView: CarouselView<CarouselViewCell>
    
    var showingType: CarouselShowType = .success
    
    var carouselVM: [CarouselItemViewModel]? = nil

    public var listPresenter: ListPresenter?
    
    init(carouselView: CarouselView<CarouselViewCell>) {
        self.carouselView = carouselView
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        setVM()
    }
    public func setVM() {
        switch showingType {
        case .success:
            //CASE 1: using the view model
            carouselVM = [
                CarouselItemViewModel(title: "Monday ☹️", backgroundColor: UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1.0) ),
                CarouselItemViewModel(title: "Tuesday 🙁", backgroundColor: UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1.0) ),
                CarouselItemViewModel(title: "Wednesday 😐", backgroundColor: UIColor(red: 0.9, green: 1, blue: 0.7, alpha: 1.0) ),
                CarouselItemViewModel(title: "Thursday 🙂", backgroundColor: UIColor(red: 0.8, green: 1, blue: 0.5, alpha: 1.0) ),
                CarouselItemViewModel(title: "Friday 😄🎉🤙", backgroundColor: UIColor(red: 0.2, green: 1, blue: 0.2, alpha: 1.0) )
            ]
        //CASE 2: the viewModel is empty
        case .emptyCustom:
            //ADD THESE 4 LINES IN ORDER TO HAVE A CUSTOM UIVIEW FOR ERROR/EMPTY CASES
            carouselVM = []
            listPresenter = self
            guard let presenter = listPresenter else { return }
            carouselView.listPresenter = presenter
        case .emptyDefault:
            carouselVM = []
            //CASE 3: the viewModel is nil
        case .errorCustom:
            //ADD THESE 4 LINES IN ORDER TO HAVE A CUSTOM UIVIEW FOR ERROR/EMPTY CASES
            listPresenter = self
            guard let presenter = listPresenter else { return }
            carouselView.listPresenter = presenter
        case .errorDefault:
            break
        }
        
        carouselView.configure(for: carouselVM)
    }
}


//ADD THIS EXTENSION IN ORDER TO HAVE A CUSTOM UIVIEW FOR ERROR/EMPTY CASES
extension CarouselViewController: ListPresenter {
    public func errorConfiguration() -> ErrorListConfiguration {
        let errorView = CarouselCustomView(frame: CGRect(x: 0, y: 0, width: carouselView.frame.width, height: carouselView.frame.height), title: "i am a custom error view 😎")
        return ErrorListConfiguration.custom(errorView)
        
    }
    
    public var emptyConfiguration: EmptyListConfiguration {
        let errorView = CarouselCustomView(frame: CGRect(x: 0, y: 0, width: carouselView.frame.width, height: carouselView.frame.height), title: "i am a custom empty view 😎")
        return EmptyListConfiguration.custom(errorView)
    }
}


