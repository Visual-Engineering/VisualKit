//
//  ScrollableTabsDataSource.swift
//  Pods
//
//  Created by Jordi Serra on 18/5/17.
//
//

import Foundation

public protocol TabConfiguratorType: class {
    var numberOfTabs: Int { get }
    var headerHeight: CGFloat { get }
    func widthForHeader(at index: Int) -> CGFloat
    func viewController(atIndex index: Int) -> UIViewController

    
    var defaultTabIndex: Int { get }
    var tabsCentered: Bool { get }
    var barConfiguration: BarConfiguration { get }
}

//MARK: methods implemented by default

extension TabConfiguratorType {
    
    public var defaultTabIndex: Int {
        return 0
    }
    
    public var tabsCentered: Bool {
        return false
    }
    
    public var barConfiguration: BarConfiguration {
        return BarConfiguration.default
    }
    
}

