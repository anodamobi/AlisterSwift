//
//  StorageLoaderTests.swift
//  AlisterSwiftTests
//
//  Created by Oksana Kovalchuk on 6/7/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import AlisterSwift

class StorageLoaderSpec: QuickSpec {
   
    override func spec() {
        
        var storage: StorageModel!
        let original = TestViewModel(item: "test")
        let indexPath = IndexPath.init(row: 2, section: 0)
        var section: SectionModel!
        var testSectionItems = [TestViewModel]()
        
        func generateSection() -> SectionModel {
            return SectionModel.init(items: [TestViewModel(item: randomString()),
                                             TestViewModel(item: randomString())])
        }
        
        beforeEach {
            storage = StorageModel()
            testSectionItems = [TestViewModel(item: randomString()),
                                TestViewModel(item: randomString()),
                                original]
            section = SectionModel.init(items: testSectionItems)
            storage.addSection(section)
        }
        
        describe("item at indexPath") {
            
            it("_p if indexPath exist returns value", closure: {
                let value = StorageLoader.item(at: indexPath, storage: storage) as? TestViewModel
                expect(value).to(equal(original))
            })
            
            it("_n if indexPath not exist returns nil", closure: {
                let value = StorageLoader.item(at: IndexPath.init(row: 12, section: 12),
                                               storage: storage)
                expect(value).to(beNil())
            })
        }
        
        describe("section at index") {
            it("_n returns nil if section not exist", closure: {
                let result = StorageLoader.section(at: 12, storage: storage)
                expect(result).to(beNil())
            })
            
            it("_p returns correct value", closure: {
                storage.addSection(generateSection())
                storage.addSection(generateSection())
                
                let result = StorageLoader.section(at: 0, storage: storage)
                expect(result).to(beIdenticalTo(section))
            })
        }
        
        describe("items in section") {
            it("returns specified items", closure: {
                let result = StorageLoader.items(in: 0, storage: storage)
                expect(result as? [TestViewModel]).to(equal(testSectionItems))
            })
            
            it("returns empty array if section not exists", closure: {
                let result = StorageLoader.items(in: 123, storage: storage)
                expect(result).to(haveCount(0))
            })
        }
        
        describe("all items in storage") {
            it("returns items", closure: {
                storage.addSection(generateSection())
                storage.addSection(generateSection())

                let result = StorageLoader.allObjects(storage: storage)
                let numberOfItems = result.count
                
                expect(numberOfItems).to(equal(7))
            })
        }
        
        describe("indexPathForItem") {
            it("returns nil if item not exists", closure: {
                let result = StorageLoader.indexPath(for: randomString(), storage: storage)
                expect(result).to(beNil())
            })
            
            it("returns correct indexPath", closure: {
                let result = StorageLoader.indexPath(for: original, storage: storage)
                expect(result).to(equal(indexPath))
            })
        }
        
        describe("indexPaths for items") {
            it("returns empty array if item not exists", closure: {
                let result = StorageLoader.indexPaths(for: [randomString()], storage: storage)
                expect(result).to(haveCount(0))
            })
            
            it("returns correct indexPaths when items exist", closure: {
                
                let result = StorageLoader.indexPaths(for: [original], storage: storage)
                expect(result).to(equal([indexPath]))
            })
        }
        
        describe("supplementaryModelOfKind: forSectionIndex: inStorage:") {
            it("returns correct value", closure: {
                let testKind = "kind"
                section.updateSupplementary(original, kind: testKind)
                let value = StorageLoader.supplementary(kind: testKind, section: 0, storage: storage)
                
                expect(value as? TestViewModel).to(equal(original))
            })
            
            it("returns nil if model not registered", closure: {
                let value = StorageLoader.supplementary(kind: "testkind", section: 12, storage: storage)
                expect(value).to(beNil())
            })
        }
    }
}
