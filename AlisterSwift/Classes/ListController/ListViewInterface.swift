//
//  ListViewInterface.swift
//  Alister
//
//  Created by Simon Kostenko on 5/31/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit

protocol ListViewInterface: class {
    
    var animationKey: String { get }
    var reloadingDuration: Double { get }
    
    func registerSupplementaryClass(_ supplementaryClass: AnyClass, reuseIdentifier: String, kind: String)
    func registerCellClass(_ cellClass: AnyClass, forReuseIdentifier identifier: String)
    
    func cell(identifier: String, at: IndexPath) -> ReusableViewInterface?
    func supplementaryView(identifier: String, kind: String, at: IndexPath?) -> ReusableViewInterface?
    
    var scrollView: UIScrollView? { get }

    var dataSource: AnyObject? { get set }
    var delegate: AnyObject? { get set }
    
    func performUpdate(_ update: StorageUpdateModel, animated: Bool)
    
    func reloadData()
    
    func reloadData(animated: Bool)
    
    // MARK: - Default -
    var defaultHeaderKind: String { get }
    var defaultFooterKind: String { get }
}

extension ListViewInterface {
    
    var reloadingDuration: Double {
        return 0.25
    }
    
    func reloadData(animated: Bool) {
        
        reloadData()
        if animated {
            let animation = CATransition()
            animation.type = kCATransitionFromBottom
            animation.subtype = kCATransitionFromBottom
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fillMode = kCAFillModeBoth
            animation.duration = reloadingDuration
            scrollView?.layer.add(animation, forKey: animationKey)
        }
    }
}
