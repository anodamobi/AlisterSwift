//
//  ListTableViewTests.swift
//  AlisterSwiftTests
//
//  Created by Maxim Danilov on 6/1/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable import AlisterSwift

class ListViewDataSource: NSObject, UITableViewDataSource {
    
    var datasource: [Int] = [1,2,3,4,5,6,7]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ANODA") ?? UITableViewCell()
    }
}

class ListTableViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("ListTableView") {
    
            var dataSource: ListViewDataSource!
            var tableView: UITableView!
            var listTableView: ListTableView!
            
            beforeEach {
                dataSource = ListViewDataSource()
                tableView = UITableView()
                listTableView = ListTableView(tableView: tableView)
                listTableView.registerCellClass(UITableViewCell.self, forReuseIdentifier: "ANODA")
                listTableView.dataSource = dataSource
            }
            
            context("table data is consistent", {
                it("scroll view exists") {
                    expect(listTableView.scrollView).notTo(beNil())
                    expect(listTableView.scrollView).to(beAKindOf(UIScrollView.self))
                }

                it("dataSource not nil") {
                    expect(tableView.dataSource).notTo(beNil())
                }
            })
            
            context("perfoming update") {
                
                var updateModel = StorageUpdateModel()
                afterEach {
                    updateModel = StorageUpdateModel()
                }
                
                it("removing 1 row") {
                
                    let indexPath = IndexPath(row: 0, section: 0)
                    dataSource.datasource.removeFirst()
                    updateModel.addDeletedIndexPaths([indexPath])
                    listTableView.performUpdate(updateModel, animated: false)
                    
                    let numberOfRows = tableView.numberOfRows(inSection: 0)
                    expect(numberOfRows) == dataSource.datasource.count
                }
                
                it("inserting 1 row") {
                    
                    let insertedIndexPath = IndexPath(row: 5, section: 0)
                    dataSource.datasource.insert(8, at: 5)
                    updateModel.addInsertedIndexPaths([insertedIndexPath])
                    listTableView.performUpdate(updateModel, animated: false)
                    
                    let numberOfRows = tableView.numberOfRows(inSection: 0)
                    expect(numberOfRows) == dataSource.datasource.count
                }
                
                it("inserting 1 row and removing 2 rows") {
                    
                    dataSource.datasource.insert(8, at: 5)
                    dataSource.datasource.remove(at: 1)
                    dataSource.datasource.remove(at: 3)
                    updateModel.addInsertedIndexPaths([IndexPath(row: 5, section: 0)])
                    updateModel.addDeletedIndexPaths([IndexPath(row: 1, section: 0),
                                                      IndexPath(row: 3, section: 0)])
                    listTableView.performUpdate(updateModel, animated: false)
                    
                    let numberOfRows = tableView.numberOfRows(inSection: 0)
                    expect(numberOfRows) == dataSource.datasource.count
                }
                
                it("inserting and removing row at same index path") {
                    
                    dataSource.datasource.insert(8, at: 5)
                    dataSource.datasource.remove(at: 5)
                    updateModel.addInsertedIndexPaths([IndexPath(row: 5, section: 0)])
                    updateModel.addDeletedIndexPaths([IndexPath(row: 5, section: 0)])
                    listTableView.performUpdate(updateModel, animated: false)
                    
                    let numberOfRows = tableView.numberOfRows(inSection: 0)
                    expect(numberOfRows) == dataSource.datasource.count
                }
                
                it("reload data") {
                    dataSource.datasource = [5,4,3]
                    listTableView.reloadData()
                    
                    let numberOfRows = tableView.numberOfRows(inSection: 0)
                    expect(numberOfRows) == dataSource.datasource.count
                }
            }
        }
    }
}
