//
//  ANListControllerReloadOperation.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import QuartzCore

class ListControllerReloadOperation: Operation {
    
    var shouldAnimate: Bool = false
    weak var delegate: ListControllerUpdateServiceInterface?
    
    override func main() {
        if !isCancelled {
            delegate?.performListViewReload(animated: shouldAnimate)
        }
    }
}
