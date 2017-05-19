//
//  ScrollableTabsDataSource.swift
//  Pods
//
//  Created by Jordi Serra on 18/5/17.
//
//

import Foundation

public protocol ScrollableTabsDataSource: class {
    func numberOfTabs() -> Int
    func headerView(at index: Int) -> UIView
    func contentView(at index: Int) -> UIView
    func widthForHeader(at index: Int) -> CGFloat
    func headerHeight() -> CGFloat
    
    var defaultTabIndex: Int { get }
    var barConfiguration: BarConfiguration { get }
    var tabsCentered: Bool { get }
}


//MARK: methods implemented by default

extension ScrollableTabsDataSource {
    
    public var defaultTabIndex: Int {
        return 0
    }
    
    public var barConfiguration: BarConfiguration {
        return BarConfiguration.default
    }
    
    public var tabsCentered: Bool {
        return false
    }
}

