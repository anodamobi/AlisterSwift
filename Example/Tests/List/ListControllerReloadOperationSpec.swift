//
//  ListControllerReloadOperationTests.swift
//  AlisterSwiftTests
//
//  Created by Alexander Kravchenko on 6/5/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AlisterSwift

class ListControllerReloadOperationSpec: QuickSpec {
    
    override func spec() {
        
        describe("Reload Operation tests") {
            
            var reloadOperation: ListControllerReloadOperation!
            var delegate: UpdateOpDelegate!
            
            beforeEach {
                reloadOperation = ListControllerReloadOperation()
                delegate = UpdateOpDelegate()
                reloadOperation.delegate = delegate
            }
            
            it("List controller reload operation delegate", closure: {
                reloadOperation.start()
                
                expect(delegate.listReloadCounter).to(equal(1))
                expect(delegate.storageReloadCounter).to(equal(0))
                expect(delegate.updateCounter).to(equal(0))
            })

            it("List controller reload operation delegate should animate", closure: {
                reloadOperation.shouldAnimate = true
                reloadOperation.start()
                    
                expect(delegate.listReloadCounter).to(equal(1))
                expect(delegate.storageReloadCounter).to(equal(0))
                expect(delegate.updateCounter).to(equal(0))
            })
        }
    }
}
