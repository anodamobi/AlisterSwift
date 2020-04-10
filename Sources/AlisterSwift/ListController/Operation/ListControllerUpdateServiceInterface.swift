//
//  ANListControllerUpdateServiceInterface.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

protocol ListControllerUpdateServiceInterface: class {
    func storageNeedsReload(_ identifier: String, isAnimated: Bool)
    func performListViewUpdate(_ update: StorageUpdateModel, animated: Bool)
    func performListViewReload(animated: Bool)
    
}
