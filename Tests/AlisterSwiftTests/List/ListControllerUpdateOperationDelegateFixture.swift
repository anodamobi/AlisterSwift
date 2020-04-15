//
//  ListControllerUpdateOperationFixture.swift
//  AlisterSwiftTests
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit
@testable import AlisterSwift

class UpdateOpDelegate: ListControllerUpdateServiceInterface {
    
    var storageReloadCounter: Int = 0
    var listReloadCounter: Int = 0
    var updateCounter: Int = 0
    
    func storageNeedsReload(_ identifier: String, isAnimated: Bool) {
        storageReloadCounter += 1
    }
    
    func performListViewUpdate(_ update: StorageUpdateModel, animated: Bool) {
        updateCounter += 1
    }
    
    func performListViewReload(animated: Bool) {
        listReloadCounter += 1
    }
}
