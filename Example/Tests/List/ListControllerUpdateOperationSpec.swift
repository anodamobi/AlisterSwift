//
//  ListControllerUpdateOperationTests.swift
//  AlisterSwiftTests
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AlisterSwift

class ListControllerUpdateOperationSpec: QuickSpec {
    
    override func spec() {
        
        describe("Update Operation tests") {
            
            var updateOperation: ListControllerUpdateOperation!
            var delegate: UpdateOpDelegate!
            
            beforeEach {
                updateOperation = ListControllerUpdateOperation()
                updateOperation.name = "Test"
                delegate = UpdateOpDelegate()
                updateOperation.delegate = delegate
            }
            
            it("perform animated update called", closure: {
                updateOperation.updateGenerated(StorageUpdateModel.someValuesInside())
                updateOperation.shouldAnimate = true
                updateOperation.start()
                
                expect(delegate.updateCounter) == 1
                expect(delegate.storageReloadCounter) == 0
                expect(updateOperation.isFinished).toEventually(equal(true))
            })
            
            it("calls reload if update is not animated", closure: {
                updateOperation.updateGenerated(StorageUpdateModel.someValuesInside())
                updateOperation.shouldAnimate = false
                updateOperation.start()
                
                expect(delegate.updateCounter) == 0
                expect(delegate.storageReloadCounter) == 1
                expect(updateOperation.isFinished) == true
            })
            
            it("requires storage reload delegate called", closure: {
                updateOperation.updateGenerated(StorageUpdateModel.requiresReload())
                updateOperation.start()
                
                expect(delegate.storageReloadCounter) == 1
                expect(delegate.updateCounter) == 0
                expect(updateOperation.isFinished) == true
            })
        }
    }
}
