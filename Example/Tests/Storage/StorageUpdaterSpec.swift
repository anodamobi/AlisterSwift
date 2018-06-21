//
//  StorageUpdaterSpec.swift
//  AlisterSwiftTests
//
//  Created by Oksana Kovalchuk on 6/8/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AlisterSwift

class UpdateDelegateFixture: StorageUpdateOperationInterface {
    
    var update: StorageUpdateModel?
    
    func collect(_ update: StorageUpdateModel) {
        self.update = update
    }
}
    // swiftlint:disable type_body_length
    // swiftlint:disable function_body_length
class StorageUpdaterSpec: QuickSpec {
    
    override func spec() {
        
        var updater: StorageUpdater!
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
            updater.updateDelegate = delegate
        }
        
        describe("add") {
            
            it("item will generate inserted section and row", closure: {
                updater.add(item)
                
                expect(delegate.update?.insertedRowIndexPaths).to(equal([zeroIndexPath()]))
                expect(delegate.update?.insertedRowIndexPaths).to(haveCount(1))
                expect(delegate.update?.insertedSectionIndexes).to(contain(0))
                expect(delegate.update?.insertedSectionIndexes).to(haveCount(1))
            })
            
            it("Verify item will generate inserted section and row", closure: {
                updater.add(item)
                
                var expected = StorageUpdateModel()
                expected.addInsertedIndexPaths([IndexPath(row: 0, section: 0)])
                expected.addInsertedSectionIndex(0)
                
                expect(delegate.update).to(equal(expected))
            })
            
            it("item will be added to zero section in storage", closure: {
                updater.add(item)
                expect(storage.itemAt(zeroIndexPath()) as? TestViewModel).to(equal(item))
            })
            
            it("item added at last position in 0 section", closure: {
                updater.add(first)
                updater.add(second)
                updater.add(item)
                expect(storage.itemsInSection(0) as? [TestViewModel]).to(equal([first, second, item]))
            })
            
            it("Added item equal to the retrived one from the storage", closure: {
                updater.add(item, at: IndexPath(row: 0, section: 1))
                
                var expected = StorageUpdateModel()
                expected.addInsertedSectionIndexes(IndexSet([0, 1]))
                expected.addInsertedIndexPaths([IndexPath(row: 0, section: 1)])
                
                expect(delegate.update).to(equal(expected))
            })
            
            it("Update will be empty if row is out of bounds", closure: {
                updater.add(item, at: IndexPath(row: 2, section: 0))
                expect(delegate.update?.isEmpty()).to(beTrue())
            })
            
            describe("addItems", {
                
                it("objects from array added in a correct order", closure: {
                    updater.add(itemsArray)
                    expect(storage.itemsInSection(0) as? [TestViewModel]).to(equal(itemsArray))
                })
                
                it("Verify objects from array added in a correct order", closure: {
                    updater.add(itemsArray)
                    
                    var expected = StorageUpdateModel()
                    expected.addInsertedSectionIndex(0)
                    expected.addInsertedIndexPaths([IndexPath(row: 0, section: 0),
                                                    IndexPath(row: 1, section: 0),
                                                    IndexPath(row: 2, section: 0)])
                    expect(delegate.update).to(equal(expected))
                })
            })
            
            describe("adding objects in non-existing section creates required sections", {
                
                it("addItems", closure: {
                    updater.add(itemsArray)
                    expect(storage.sections).to(haveCount(1))
                })
                
                it("Verify addItems", closure: {
                    updater.add(itemsArray)
                    
                    var expected = StorageUpdateModel()
                    expected.addInsertedSectionIndex(0)
                    expected.addInsertedIndexPaths([IndexPath(row: 0, section: 0),
                                                    IndexPath(row: 1, section: 0),
                                                    IndexPath(row: 2, section: 0)])
                    expect(delegate.update).to(equal(expected))
                })
                
                it("addItem", closure: {
                    updater.add(item)
                    expect(storage.sections).to(haveCount(1))
                })
                
                it("Verify addItem", closure: {
                    updater.add(item)
                    
                    var expected = StorageUpdateModel()
                    expected.addInsertedSectionIndex(0)
                    expected.addInsertedIndexPaths([IndexPath(row: 0, section: 0)])
                    
                    expect(delegate.update).to(equal(expected))
                })
                
                it("addItem: toSection:", closure: {
                    updater.add(item, to: 2)
                    expect(storage.sections).to(haveCount(3))
                })
                
                it("Verify addItem: toSection:", closure: {
                    updater.add(item, to: 2)
                    
                    var expected = StorageUpdateModel()
                    expected.addInsertedSectionIndex(0)
                    expected.addInsertedIndexPaths([IndexPath(row: 0, section: 2)])
                    expected.addInsertedSectionIndex(1)
                    expected.addInsertedSectionIndex(2)
                    
                    expect(delegate.update).to(equal(expected))
                })
                
                it("addItem: at:", closure: {
                    updater.add(item, at: IndexPath(row: 0, section: 4))
                    expect(storage.sections).to(haveCount(5))
                })
            })
            
            describe("addItem: toSection:", {
                
                it("added item equal to retrived", closure: {
                    updater.add(item, to: 2)
                    expect(storage.itemAt(IndexPath(row: 0, section: 2)) as? TestViewModel).to(equal(item))
                })
            })
            
            describe("addItems: toSection:", {
                
                it("items added in a correct order", closure: {
                    updater.add(itemsArray, to: 2)
                    expect(storage.itemsInSection(2) as? [TestViewModel]).to(equal(itemsArray))
                })
            })
            
            describe("addItem: atIndexPath:", {
                
                it("items added and loaded are the same", closure: {
                    updater.add(first)
                    updater.add(second)
                    updater.add(item, at: zeroIndexPath())
                    expect(storage.itemAt(zeroIndexPath()) as? TestViewModel).to(equal(item))
                })
                
                it("returns nil if row doesn't exist", closure: {
                    expect(storage.itemAt(zeroIndexPath())).to(beNil())
                })
            })
            
            describe("reload", {
                
                it("empty update if item doesn't exist in storage", closure: {
                    updater.reload(item)
                    expect(delegate.update?.isEmpty()).to(beTrue())
                })

                it("Verify item reloaded if exists", closure: {
                    updater.add(item)
                    updater.reload(item)
                    
                    var expected = StorageUpdateModel()
                    expected.addUpdatedIndexPaths([IndexPath(row: 0, section: 0)])
                    
                    expect(delegate.update).to(equal(expected))
                })
            })
            
            describe("move", {
                
                it("empty update if from index path not exist", closure: {
                    updater.add(itemsArray)
                    updater.move(from: IndexPath(row: 12, section: 1), to: zeroIndexPath())
                    expect(delegate.update?.isEmpty()).to(beTrue())
                })
                
                it("empty update if to index path not exist", closure: {
                    updater.add(itemsArray)
                    updater.move(from: zeroIndexPath(), to: IndexPath(row: 12, section: 1))
                    expect(delegate.update?.isEmpty()).to(beTrue())
                })
                
                it("generates update if data is valid", closure: {
                    
                    let toIndexPath = IndexPath(row: 0, section: 1)
                    let movedIndexPath = MovedIndexPath(from: zeroIndexPath(), to: toIndexPath)
                    updater.add(itemsArray)
                    updater.move(from: zeroIndexPath(), to: toIndexPath)
                    
                    expect(delegate.update?.isEmpty()).to(beFalse())
                    expect(delegate.update?.movedRowsIndexPaths).to(contain(movedIndexPath))
                    expect(delegate.update?.movedRowsIndexPaths).to(haveCount(1))
                })
                
                it("will move item successfully", closure: {
                    let fromIndexPath = IndexPath(row: 0, section: 0)
                    let toIndexPath = IndexPath(row: 1, section: 0)
                    
                    updater.add(item)
                    updater.move(from: fromIndexPath, to: toIndexPath)
                    
                    var expected = StorageUpdateModel()
                    let movedIndexPathModel = MovedIndexPath(from: fromIndexPath, to: toIndexPath)
                    expected.addMovedIndexPaths([movedIndexPathModel])
                    
                    expect(delegate.update).to(equal(expected))
                })
            })
            
            describe("move without update", {
                
                let newIndexPath = IndexPath(item: 0, section: 1)
                
                beforeEach {
                    storage.addSection(SectionModel(items: [item]))
                }
                
                it("will move item successfully", closure: {
                    updater.moveWithoutUpdate(from: zeroIndexPath(), to: newIndexPath)
                    expect(storage.itemAt(newIndexPath) as? TestViewModel).to(equal(item))
                })
                
                it("nothing will happens if destination indexPath is unreachable", closure: {
                    
                })
            })
            
            describe("replace", {
                
                it("Successfully replaces item", closure: {
                    updater.add(item)
                    updater.replace(item, with: first)
                    
                    var expected = StorageUpdateModel()
                    expected.addUpdatedIndexPaths([IndexPath(row: 0, section: 0)])
                    
                    expect(delegate.update).to(equal(expected))
                })
            })
            
            describe("update section header", {
                
                beforeEach {
                    storage.headerKind = "testKind"
                }
                
                it("updates model successfully", closure: {
                    updater.update(headerModel: item, section: 0)
                    expect(storage.sectionAt(0)?.supplementaryModel(storage.headerKind) as? TestViewModel).to(equal(item))
                })
                
                it("creates section if not exist", closure: {
                    updater.update(headerModel: item, section: 3)
                    expect(delegate.update?.insertedSectionIndexes).to(haveCount(4))
                })
                
                it("creates update for updated section", closure: {
                    //this will init 0 section
                    updater.add(item)
                    
                    updater.update(headerModel: item, section: 0)
                    expect(delegate.update?.updatedSectionIndexes).to(equal(IndexSet([0])))
                })
                
                it("no update will be generated if index is negative", closure: {
                    updater.update(headerModel: item, section: -1)
                    expect(delegate.update?.isEmpty()).to(beTrue())
                })
            })
            
            
            describe("update section footer", {
                
                beforeEach {
                    storage.footerKind = "testKind"
                }
                
                 //TODO: separate
                it("updates model successfully", closure: {
                    updater.update(footerModel: item, section: 0)
                    expect(storage.sectionAt(0)?.supplementaryModel(storage.footerKind) as? TestViewModel).to(equal(item))
                })
                //TODO: separate
                it("creates section if not exist", closure: {
                    updater.update(footerModel: item, section: 3)
                    
                    expect(delegate.update?.insertedSectionIndexes).to(haveCount(4))
                })
                
                it("creates update for updated section", closure: {
                    //this will init 0 section
                    updater.add(item)
                    
                    updater.update(footerModel: item, section: 0)
                    var update = StorageUpdateModel()
                    update.addUpdatedSectionIndex(0)
                    
                    expect(delegate.update).to(equal(update))
                })
                
                it("no update will be generated if index is negative", closure: {
                    updater.update(footerModel: item, section: -1)
                    expect(delegate.update?.isEmpty()).to(beTrue())
                })
            })
            
            describe("remove supplementary", {
                //TODO:
            })
            
            describe("Verify update for addItems: to section") {
                
                it("Items added in the correct order", closure: {
                    updater.add(itemsArray, to: 3)
                    
                    var expected = StorageUpdateModel()
                    expected.addInsertedSectionIndexes(IndexSet([0, 1, 2, 3]))
                    expected.addInsertedIndexPaths([IndexPath(row: 0, section: 3),
                                                    IndexPath(row: 1, section: 3),
                                                    IndexPath(row: 2, section: 3)])
                    expect(delegate.update).to(equal(expected))
                })
                
                it("Update will be empty if section index < 0", closure: {
                    updater.add(itemsArray, to: -1)
                    expect(delegate.update?.isEmpty()).to(beTrue())
                })
            }
        }
    }
}
