//
//  ListController.swift
//  Alister-Example
//
//  Created by Oksana Kovalchuk on 6/4/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit

public protocol ReusableViewInterface {
    func update(_ model: ViewModelInterface)
}

protocol ListControllerUpdateServiceDelegate: class {
    func allUpdatesFinished()
}

open class ListController: NSObject {
    
    public var storage: Storage {
        didSet {
            attachStorage(storage)
        }
    }
    var listView: ListViewInterface
    var itemsHandler: ItemsHandler
    var updateService: UpdateService
    
    var updatesFinishedTrigger: (()->())?
    
    public lazy var searchManager: SearchManager = {
        let manager = SearchManager()
        manager.delegate = self
        return manager
    }()
    
    init(_ listView: ListViewInterface) {
        self.listView = listView
        storage = Storage()

        itemsHandler = ItemsHandler(listView: listView)
        updateService = UpdateService(listView: listView)
        
        super.init()
        
        attachStorage(storage)
        
        listView.delegate = self
        listView.dataSource = self
        updateService.delegate = self
    }
    
    deinit {
        listView.delegate = nil
        listView.dataSource = nil
        storage.updatesHandler = nil
    }
    
    public func activeStorage() -> Storage {
        return searchManager.isSearching ? searchManager.storage! : storage //TODO: force temp
    }
    
    public func attachSearchBar(_ searchBar: UISearchBar) {
        searchManager.searchBar = searchBar
    }

    
    public func configureCells(_ block: (ListControllerReusableInterface) -> ()) {
        block(itemsHandler)
    }
    
    public func addUpdatesFinishedTriggerBlock(_ block: @escaping ()->()) {
        updatesFinishedTrigger = block
    }
    
    
    //MARK: Private
    
    private func attachStorage(_ storage: Storage) {
        storage.updatesHandler = updateService
        updateService.storageNeedsReload(storageID: storage.storageID, shouldAnimate: false)
        storage.update(headerKind: listView.defaultHeaderKind, footerKind: listView.defaultFooterKind)
    }
}

extension ListController: ListControllerUpdateServiceDelegate {
    
    func allUpdatesFinished() {
        updatesFinishedTrigger?()
    }
}

extension ListController: SearchManagerDelegate {
    
    func didCancelSearch() {
        storage.updatesHandler = updateService
    }
    
    func searchStorageHasBeenCreated(_ storage: Storage) {
        attachStorage(storage)
    }
    
    func mainStorage() -> Storage {
        return storage
    }

    func performSearch(string: String, scope: Int) {
        searchManager.performSearch(string: string, scope: scope)
    }
}
