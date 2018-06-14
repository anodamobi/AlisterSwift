//
//  SearchManagerTests.swift
//  AlisterSwiftTests
//
//  Created by Alexander Kravchenko on 6/5/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import AlisterSwift

class TestListController: ListController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class SearchManagerSpec: QuickSpec {
    
    class TestModel: ViewModelInterface & Equatable {
        
        var name: String
        
        var searchEvaluation: SearchEval? {
            let eval: SearchEval = { [unowned self] string, scope in
                return self.name.contains(string)
            }
            return eval
        }
        
        init(name: String) {
            self.name = name
        }
        
        static func == (lhs: TestModel, rhs: TestModel) -> Bool {
            return lhs.name == rhs.name
        }
        
    }
    
    override func spec() {
        
        describe("Search Manager tests") {
            
            var tableView: UITableView!
            var listView: ListTableView!
            var listController: ListController!
            var searchManager: SearchManager!
            var storage: Storage!
            var searchBar: UISearchBar!
            
            var model1: TestModel!
            var model2: TestModel!
            var model3: TestModel!
            
            beforeEach {
                tableView = UITableView()
                listView = ListTableView(tableView: tableView)
                listController = TestListController(listView)
                storage = Storage()
                searchBar = UISearchBar()
                
                searchManager = SearchManager()
                
                searchManager.delegate = listController
                searchManager.searchBar = searchBar
                
                listController.storage = storage
                
                model1 = TestModel(name: "Model 1")
                model2 = TestModel(name: "Model 2")
                model3 = TestModel(name: "Model 3")
            }
            
            it("Search by some search string", closure: {
                storage.add([model1, model2, model3])
                searchManager.performSearch(string: "Model 1", scope: 0)
                
                let items = searchManager.storage?.itemsIn(section: 0) as? [TestModel]
                let numberOfItems = items?.count ?? -1
                let firstItemName = items?.first?.name ?? "Undefined"
                
                expect(numberOfItems).toEventually(equal(1), timeout: 1.0)
                expect(firstItemName).toEventually(equal(model1.name), timeout: 1.0)
            })
            
            it("Search by different scopes", closure: {
                storage.add([model1, model2, model3])
                searchManager.performSearch(string: "Model 1", scope: 0)
                searchManager.performSearch(string: "Model 2", scope: 1)
                
                let items = searchManager.storage?.itemsIn(section: 0) as? [TestModel]
                let numberOfItems = items?.count ?? -1
                let firstItemName = items?.first?.name ?? "Undefined"
                
                expect(numberOfItems).toEventually(equal(1), timeout: 1.0)
                expect(firstItemName).toEventually(equal(model2.name), timeout: 1.0)
            })
            
            it("Search many objects in different scopes", closure: {
                storage.add([model1, model2, model3])
                
                searchManager.performSearch(string: "Model 4", scope: 0)
                
                let numberOfItems1 = searchManager.storage?.itemsIn(section: 0).count ?? -1
                expect(numberOfItems1).toEventually(equal(0), timeout: 1.0)
                
                searchManager.performSearch(string: "Model", scope: 1)
                
                let numberOfItems2 = searchManager.storage?.itemsIn(section: 0).count ?? -1
                expect(numberOfItems2).toEventually(equal(3), timeout: 1.0)
            })
        }
    }
}
