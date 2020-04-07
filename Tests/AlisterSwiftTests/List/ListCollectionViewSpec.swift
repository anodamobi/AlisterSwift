//
//  ListCollectionViewTests.swift
//  AlisterSwiftTests
//
//  Created by Simon Kostenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable import AlisterSwift

class ListCollectionViewDataSourceFixture: NSObject, UICollectionViewDataSource {
    
    var datasource: [Int] = [1, 2, 3, 4, 5, 6, 7]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ANODA", for: indexPath)
    }
}

class ListCollectionViewSpec: QuickSpec {
    
    // swiftlint:disable function_body_length
    override func spec() {
        
        describe("ListCollectionView") {
            
            var dataSource: ListCollectionViewDataSourceFixture!
            var collectionView: UICollectionView!
            var listCollectionView: ListCollectionView!
            
            beforeEach {
                dataSource = ListCollectionViewDataSourceFixture()
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
                listCollectionView = ListCollectionView(collectionView: collectionView)
                listCollectionView.registerCellClass(UICollectionViewCell.self, forReuseIdentifier: "ANODA")
                listCollectionView.dataSource = dataSource
            }
            
            context("table data is consistent", closure: {
                it("scroll view exists") {
                    expect(listCollectionView.scrollView).notTo(beNil())
                }
                
                it("table view can be casted to scroll view") {
                    expect(listCollectionView.scrollView).to(beAKindOf(UIScrollView.self))
                }
                
                it("dataSource not nil") {
                    expect(collectionView.dataSource).notTo(beNil())
                }
            })
            
            context("perfoming update") {
                
                var updateModel: StorageUpdateModel!
                beforeEach {
                    updateModel = StorageUpdateModel()
                }
                
                it("removing 1 row") {
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    dataSource.datasource.removeFirst()
                    updateModel.addDeletedIndexPaths([indexPath])
                    listCollectionView.performUpdate(updateModel, animated: false)
                    
                    let numberOfItems = collectionView.numberOfItems(inSection: 0)
                    expect(numberOfItems).to(equal(dataSource.datasource.count))
                }
                
                it("inserting 1 row") {
                    
                    let insertedIndexPath = IndexPath(row: 5, section: 0)
                    dataSource.datasource.insert(8, at: 5)
                    updateModel.addInsertedIndexPaths([insertedIndexPath])
                    listCollectionView.performUpdate(updateModel, animated: false)
                    
                    let numberOfItems = collectionView.numberOfItems(inSection: 0)
                    expect(numberOfItems).to(equal(dataSource.datasource.count))
                }
                
                it("inserting 1 row and removing 2 rows") {
                    
                    dataSource.datasource.insert(8, at: 5)
                    dataSource.datasource.remove(at: 1)
                    dataSource.datasource.remove(at: 3)
                    updateModel.addInsertedIndexPaths([IndexPath(row: 5, section: 0)])
                    updateModel.addDeletedIndexPaths([IndexPath(row: 1, section: 0),
                                                      IndexPath(row: 3, section: 0)])
                    listCollectionView.performUpdate(updateModel, animated: false)
                    
                    let numberOfItems = collectionView.numberOfItems(inSection: 0)
                    expect(numberOfItems).to(equal(dataSource.datasource.count))
                }
                
                it("inserting and removing row at same index path") {
                    
                    dataSource.datasource.insert(8, at: 5)
                    dataSource.datasource.remove(at: 5)
                    updateModel.addInsertedIndexPaths([IndexPath(row: 5, section: 0)])
                    updateModel.addDeletedIndexPaths([IndexPath(row: 5, section: 0)])
                    listCollectionView.performUpdate(updateModel, animated: false)
                    
                    let numberOfItems = collectionView.numberOfItems(inSection: 0)
                    expect(numberOfItems).to(equal(dataSource.datasource.count))
                }
                
                it("removing all items") {
                    
                    updateModel.addDeletedIndexPaths(dataSource.datasource.enumerated().map {
                        IndexPath(row: $0.offset, section: 0)
                    })
                    dataSource.datasource.removeAll()
                    listCollectionView.performUpdate(updateModel, animated: true)
                    
                    let numberOfItems = collectionView.numberOfItems(inSection: 0)
                    expect(numberOfItems).to(equal(dataSource.datasource.count))
                }
                
                it("adding item to empty collection view") {
                    
                    dataSource.datasource.insert(8, at: 0)
                    updateModel.addInsertedIndexPaths([IndexPath(row: 0, section: 0)])
                    listCollectionView.performUpdate(updateModel, animated: true)
                    
                    let numberOfItems = collectionView.numberOfItems(inSection: 0)
                    expect(numberOfItems).to(equal(dataSource.datasource.count))
                }
            }
        }
    }
}
