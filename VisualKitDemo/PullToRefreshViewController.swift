//
//  PullToRefreshViewController.swift
//  VisualKitDemo
//
//  Created by Alba Luján on 24/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import UIKit
import VisualKit

public class PullToRefreshViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        let simpleView: UIScrollView = {
            let v = UIScrollView()
            let titleLabel: UILabel = {
                let label = UILabel()
                label.textAlignment = .center
                label.text = "Pull me to refresh the page \(String(format: "%C", 0xe04f))"
                return label
            }()
            v.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor).isActive = true
            return v
        }()
        
        
        //WHAT YOU NEED TO ADD REFRESH CONTROL TO YOUR SIMPLE VIEW
        simpleView.addRefresh { (completion) in
            print("i am reloading from the controller")
            let deadlineTime = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.view.backgroundColor = .green
                completion()
            }
        }
        
        view.addSubview(simpleView)
        simpleView.translatesAutoresizingMaskIntoConstraints = false
        simpleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        simpleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        simpleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        simpleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
