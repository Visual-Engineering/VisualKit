//
//  CarouselViewController.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 26/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

public struct CarouselItemViewModel {
    let title: String
    let backgroundColor: UIColor
}

public class CarouselViewController: UIViewController {
        
    lazy var carouselView = CarouselView<CarouselViewCell>(cellSize: CGSize(width: 350, height: 350))

    //CASE 1: using the view model
//    let carouselVM = [
//        CarouselItemViewModel(title: "Monday ☹️", backgroundColor: UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 1.0) ),
//        CarouselItemViewModel(title: "Tuesday 🙁", backgroundColor: UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1.0) ),
//        CarouselItemViewModel(title: "Wednesday 😐", backgroundColor: UIColor(red: 0.9, green: 1, blue: 0.7, alpha: 1.0) ),
//        CarouselItemViewModel(title: "Thursday 🙂", backgroundColor: UIColor(red: 0.8, green: 1, blue: 0.5, alpha: 1.0) ),
//        CarouselItemViewModel(title: "Friday 😄🎉🤙", backgroundColor: UIColor(red: 0.2, green: 1, blue: 0.2, alpha: 1.0) )
//    ]
    
    //CASE 2: the viewModel is empty
    
    //let carouselVM: [CarouselItemViewModel] = []
    
    //CASE 3: the viewModel is nil
    
    let carouselVM: [CarouselItemViewModel]? = nil
    
    public var listPresenter: ListPresenter?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        carouselView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //ADD THESE 4 LINES IN ORDER TO HAVE A CUSTOM UIVIEW FOR ERROR/EMPTY CASES
        carouselView.listPresenter = self as ListPresenter
        
        listPresenter = self
        guard let presenter = listPresenter else {
            return
        }
        carouselView.listPresenter = presenter
        //////
        
        carouselView.configure(for: carouselVM)
    }
}


//ADD THIS EXTENSION IN ORDER TO HAVE A CUSTOM UIVIEW FOR ERROR/EMPTY CASES

extension CarouselViewController: ListPresenter {
    public func errorConfiguration() -> ErrorListConfiguration {
        let emptyView = CarouselCustomView(frame: CGRect(x: 0, y: 0, width: carouselView.frame.width, height: carouselView.frame.height), title: "i am a custom error view 😎")
        return ErrorListConfiguration.custom(emptyView)
        
    }
    
    public var emptyConfiguration: EmptyListConfiguration {
        let errorView = CarouselCustomView(frame: CGRect(x: 0, y: 0, width: carouselView.frame.width, height: carouselView.frame.height), title: "i am a custom empty view 😎")
        return EmptyListConfiguration.custom(errorView)
    }
}


