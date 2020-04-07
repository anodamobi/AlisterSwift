//
//  StorageTests.swift
//  AlisterSwiftTests
//
//  Created by Alexander Kravchenko on 06.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AlisterSwift

class StorageSpec: QuickSpec {
    
    // swiftlint:disable function_body_length
    override func spec() {
        
        describe("Add sections tests") {
            var storage: Storage!
            
            beforeEach {
                storage = Storage()
            }
            
            it("Adding sections at diffent indexes", closure: {
                storage.addSection(at: 0)
                storage.addSection(at: 1)
                storage.addSection(at: 2)
                storage.addSection(at: 2)
                storage.addSection(at: 10)
                
                let sections = storage.sections()
                expect(sections.count).toEventually(equal(4), timeout: 1.0)
            })
        }
        
        describe("Add models tests") {
            
            var storage: Storage!
            var model1: TestViewModel!
            var model2: TestViewModel!
            var model3: TestViewModel!
            
            beforeEach {
                storage = Storage()
                model1 = TestViewModel(item: "Model 1")
                model2 = TestViewModel(item: "Model 2")
                model3 = TestViewModel(item: "Model 3")
            }
            
            it("Adding elements to the default section", closure: {
                storage.add([model1, model2, model3])
                
                let items = storage.itemsIn(section: 0)
                expect(items.count).toEventually(equal(3), timeout: 1.0)
            })
            
            it("Adding elements to different sections", closure: {
                storage.add([model1, model2], to: 1)
                storage.add(model3, to: 2)
                
                let section0Items = storage.itemsIn(section: 0)
                let section1Items = storage.itemsIn(section: 1)
                let section2Items = storage.itemsIn(section: 2)
                
                expect(section0Items.count).toEventually(equal(0), timeout: 1.0)
                expect(section1Items.count).toEventually(equal(2), timeout: 1.0)
                expect(section2Items.count).toEventually(equal(1), timeout: 1.0)
            })
            
            it("Adding elements at IndexPath", closure: {
                storage.add(model1, at: IndexPath(row: 0, section: 0))
                storage.add(model2, at: IndexPath(row: 1, section: 0))
                
                storage.add(model3, at: IndexPath(row: 0, section: 1))
                
                let section0Items = storage.itemsIn(section: 0)
                let section1Items = storage.itemsIn(section: 1)
                
                expect(section0Items.count).toEventually(equal(2), timeout: 1.0)
                expect(section1Items.count).toEventually(equal(1), timeout: 1.0)
            })

            it("Adding elements at multiple IndexPaths", closure: {
                storage.add([model1, model2], at: [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)])
                storage.add([model3], at: [IndexPath(row: 0, section: 1)])

                let section0Items = storage.itemsIn(section: 0)
                let section1Items = storage.itemsIn(section: 1)

                expect(section0Items.count).toEventually(equal(2), timeout: 1.0)
                expect(section1Items.count).toEventually(equal(1), timeout: 1.0)
            })
        }
        
        describe("Get models tests") {
            
            var storage: Storage!
            var model1: TestViewModel!
            var model2: TestViewModel!
            var model3: TestViewModel!
            
            beforeEach {
                storage = Storage()
                model1 = TestViewModel(item: "Model 1")
                model2 = TestViewModel(item: "Model 2")
                model3 = TestViewModel(item: "Model 3")
            }
            
            it("Get item at IndexPath", closure: {
                storage.add([model1, model2, model3])
                let item1 = storage.object(at: IndexPath(row: 0, section: 0)) as? TestViewModel
                let item1Name = item1?.item ?? "Undefined"
                expect(item1Name).toEventually(equal(model1.item), timeout: 1.0)
            })
            
            it("Get item's IndexPath", closure: {
                storage.add([model1, model2, model3])
                let indexPath = storage.indexPath(for: model3)
                let row = indexPath?.row ?? -1
                let section = indexPath?.section ?? -1
                
                expect(row).toEventually(equal(2), timeout: 1.0)
                expect(section).toEventually(equal(0), timeout: 1.0)
            })
            
            it("Replace items", closure: {
                storage.add([model1, model2])
                storage.replace(model1, on: model3)

                let newItem = storage.object(at: IndexPath(row: 0, section: 0)) as? TestViewModel
                let itemName = newItem?.item ?? "Undefined"
                
                expect(itemName).toEventually(equal(model3.item), timeout: 1.0)
            })
            
            it("Move items", closure: {
                storage.add([model1, model2])
                storage.move(from: IndexPath(row: 1, section: 0),
                             to: IndexPath(row: 0, section: 0))
                
                let item = storage.object(at: IndexPath(row: 0, section: 0)) as? TestViewModel
                let itemName = item?.item ?? "Undefined"
                
                expect(itemName).toEventually(equal(model2.item), timeout: 1.0)
            })
        }
        
        describe("Delete models tests") {
            
            var storage: Storage!
            var model1: TestViewModel!
            var model2: TestViewModel!
            var model3: TestViewModel!
            
            beforeEach {
                storage = Storage()
                model1 = TestViewModel(item: "Model 1")
                model2 = TestViewModel(item: "Model 2")
                model3 = TestViewModel(item: "Model 3")
            }
            
            it("Remove item", closure: {
                storage.add([model1, model2, model3])
                storage.remove(model2)
                
                let numberOfElements = storage.itemsIn(section: 0).count
                let itemAtIndex = storage.object(at: IndexPath(row: 1, section: 0)) as? TestViewModel
                let itemName = itemAtIndex?.item ?? "Undefined"
                
                expect(numberOfElements).toEventually(equal(2), timeout: 1.0)
                expect(itemName).toEventually(equal(model3.item), timeout: 1.0)
            })
            
            it("Remove item at IndexPath", closure: {
                storage.add([model1, model2, model3])
                storage.remove(IndexPath(row: 1, section: 0))
                
                let numberOfElements = storage.itemsIn(section: 0).count
                let itemAtIndex = storage.object(at: IndexPath(row: 1, section: 0)) as? TestViewModel
                let itemName = itemAtIndex?.item ?? "Undefined"
                
                expect(numberOfElements).toEventually(equal(2), timeout: 1.0)
                expect(itemName).toEventually(equal(model3.item), timeout: 1.0)
            })
            
            it("Remove section", closure: {
                storage.add([model1, model2])
                storage.add(model3, to: 1)
                storage.remove([0])
                
                let section1 = storage.section(at: 1)
                let itemAtIndex = storage.object(at: IndexPath(row: 0, section: 0)) as? TestViewModel
                let itemName = itemAtIndex?.item ?? "Undefined"
                
                expect(section1).toEventually(beNil(), timeout: 1.0)
                expect(itemName).toEventually(equal(model3.item), timeout: 1.0)
            })
        }
    }
}
