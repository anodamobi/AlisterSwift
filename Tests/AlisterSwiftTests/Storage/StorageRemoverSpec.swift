//
//  StorageRemoverSpec.swift
//  AlisterSwiftTests
//
//  Created by Oksana Kovalchuk on 6/11/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AlisterSwift

class StorageRemoverSpec: QuickSpec {
    // swiftlint:disable function_body_length
    override func spec() {
        
        var updater: StorageUpdater!
        var remover: StorageRemover!
        var delegate: UpdateDelegateFixture!
        var storage: StorageModel!
        
        let first = TestViewModel(item: "1")
        let second = TestViewModel(item: "2")
        let item = TestViewModel(item: "test")
        
        let itemsArray = [first, second, item]
        
        beforeEach {
            storage = StorageModel()
            updater = StorageUpdater(model: storage)
            delegate = UpdateDelegateFixture()
            remover = StorageRemover(storageModel: storage)
            remover.updateDelegate = delegate
        }
        
        describe("remove item") {
            
            it("successfully removes item", closure: {
                updater.add(item)
                remover.remove(item)
                expect(storage.isEmpty()).to(beTruthy())
            })
            
            it("generates correct update", closure: {
                updater.add(item)
                remover.remove(item)
                
                var update = StorageUpdateModel()
                update.addDeletedIndexPaths([zeroIndexPath()])
                
                expect(delegate.update).to(equal(update))
            })
            
            it("does nothing if item doesn't exist", closure: {
                updater.add(item)
                remover.remove(first)
                expect(delegate.update?.isEmpty()).to(beTruthy())
            })
        }
        
        
        describe("removeItemsAtIndexPaths") {
            
            it("removes only specified indexPaths", closure: {
                updater.add(item)
                updater.add(itemsArray)
                
                remover.remove([zeroIndexPath()])
                expect(storage.sectionAt(0)?.objects as? [TestViewModel]).to(equal(itemsArray))
                expect(delegate.update?.deletedRowIndexPaths).to(equal([zeroIndexPath()]))
            })
            
            it("generates correct update", closure: {
                updater.add(item)
                updater.add(itemsArray)
                
                remover.remove([zeroIndexPath()])
                
                var update = StorageUpdateModel()
                update.addDeletedIndexPaths([zeroIndexPath()])
                expect(delegate.update).to(equal(update))
            })
            
            it("does nothing if indexPaths don't exist", closure: {
                remover.remove(item)
                expect(delegate.update?.isEmpty()).to(beTruthy())
            })
        }
        
        describe("removeItems") {
            
            it("removes only specified items", closure: {
                updater.add(item)
                updater.add(itemsArray)
                
                remover.remove(itemsArray)
                expect(storage.itemsInSection(0)).to(haveCount(1))
            })
            
            it("generates correct update", closure: {
                updater.add(TestViewModel(item: "123123123123"))
                updater.add(itemsArray)
                
                remover.remove(itemsArray)
                
                var update = StorageUpdateModel()
                update.addDeletedIndexPaths([IndexPath(row: 1, section: 0),
                                             IndexPath(row: 2, section: 0),
                                             IndexPath(row: 3, section: 0)])
                expect(delegate.update == update).to(beTrue())
            })
            
            it("does nothing if items don't exist", closure: {
                remover.remove(itemsArray)
                expect(delegate.update?.isEmpty()).to(beTruthy())
            })
        }
        
        describe("remove all") {
            
            it("removes all sections", closure: {
                updater.add(item)
                updater.add(first, to: 1)
                
                remover.removeAll()
                expect(storage.isEmpty()).to(beTruthy())
            })

            it("generates correct update", closure: {
                updater.add(item)
                updater.add(first, to: 1)
                
                remover.removeAll()
                
                var update = StorageUpdateModel()
                update.requiresReload = true
                expect(delegate.update).to(equal(update))
            })
            
            it("does nothing if storage is empty", closure: {
                remover.removeAll()
                expect(delegate.update?.isEmpty()).to(beTruthy())
            })
        }
        
        describe("removeSections") {
            
            it("removes only specified sections", closure: {
                updater.add(first, to: 0)
                updater.add(item, to: 1)
                
                remover.remove(sections: [0])
                
                expect(storage.itemAt(zeroIndexPath()) as? TestViewModel).to(equal(item))
            })
            
            it("generates correct update", closure: {
                updater.add(first, to: 0)
                updater.add(item, to: 1)
                
                remover.remove(sections: [0])
                
                var update = StorageUpdateModel()
                update.addDeletedSectionIndex(0)
                
                expect(delegate.update).to(equal(update))
            })
            
            it("generates empty update if array is empty", closure: {
                updater.add(first, to: 0)
                remover.remove(sections: [])
                expect(delegate.update?.isEmpty()).to(beTruthy())
            })
            
            it("generates empty update if section doesn't exist", closure: {
                remover.remove(sections: [0])
                expect(delegate.update?.isEmpty()).to(beTruthy())
            })
            
            it("removes only specified sections when has dupples", closure: {
                updater.add(first, to: 0)
                updater.add(item, to: 1)
                
                remover.remove(sections: [0, 0])
                
                expect(storage.itemAt(zeroIndexPath()) as? TestViewModel).to(equal(item))
            })
        }
        
        describe("remove footer") {
            let index = 0
            
            it("will remove footer susscessfully", closure: {
                updater.update(footerModel: item, section: index)
                remover.removeFooter(section: index)
                
                expect(storage.sectionAt(index)?.supplementaryModel(storage.footerKind)).to(beNil())
            })
            
            it("will generate correct update", closure: {
                updater.update(footerModel: item, section: index)
                remover.removeFooter(section: index)
                
                var update = StorageUpdateModel()
                update.addUpdatedSectionIndex(index)
                
                expect(delegate.update).to(equal(update))
            })
        }
        
        describe("remove header") {
            let index = 0
           
            it("will remove header susscessfully", closure: {
                updater.update(headerModel: item, section: index)
                remover.removeHeader(section: index)
                
                expect(storage.sectionAt(index)?.supplementaryModel(storage.headerKind)).to(beNil())
            })
            
            it("will generate correct update", closure: {
                updater.update(headerModel: item, section: index)
                remover.removeHeader(section: index)
                
                var update = StorageUpdateModel()
                update.addUpdatedSectionIndex(index)
                
                expect(delegate.update).to(equal(update))
            })
        }
    }
}
