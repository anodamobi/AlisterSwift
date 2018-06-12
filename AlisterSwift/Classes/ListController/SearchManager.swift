//
//  SearchManager.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 6/5/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit

protocol SearchManagerDelegate: class {
    
    func didCancelSearch()
    func searchStorageHasBeenCreated(_ storage: Storage)
    func mainStorage() -> Storage
}

public class SearchManager: NSObject {
    
    static let searchScopeNone = -1
    
    var isSearching: Bool {
        let isSearchStringNotEmpty = currentSearchString != nil && currentSearchString?.isEmpty == false
        return isSearchStringNotEmpty || currentSearchScope > SearchManager.searchScopeNone
    }
    
    var storage: Storage?
    var searchBar: UISearchBar? {
        didSet {
            searchBar?.delegate = self
            searchBar?.selectedScopeButtonIndex = SearchManager.searchScopeNone
        }
    }

    weak var delegate: SearchManagerDelegate?
    
    private var currentSearchString: String?
    private var currentSearchScope: Int = SearchManager.searchScopeNone
    
    deinit {
        searchBar?.delegate = nil
        storage?.updatesHandler = nil
    }
    
    func performSearch(string: String, scope: Int) {
        filterItems(string, scope: scope, shoudReload: false)
    }
    
    // MARK: Private methods
    
    private func filterItems(_ searchString: String?, scope: Int, shoudReload: Bool) {
        var isSearching: Bool
        
        if searchString == nil || searchString?.isEmpty == true {
            isSearching = false
        } else {
            isSearching = self.isSearching
        }
        
        let isNothingChanged = searchString == currentSearchString && scope == currentSearchScope
        if !isNothingChanged || shoudReload {
            currentSearchScope = scope
            currentSearchString = searchString
            
            handleSearch(isSearching: isSearching)
        }
    }
    
    private func handleSearch(isSearching: Bool) {
        if isSearching, !self.isSearching {
            storage?.updatesHandler = nil
            delegate?.didCancelSearch()
        } else {
            guard let delegateStorage = delegate?.mainStorage() else { return }
            delegateStorage.updatesHandler = nil
            
            storage = searchStorage(fromStorage: delegateStorage,
                                    searchString: currentSearchString ?? "",
                                    scope: currentSearchScope)
            
            if let storage = storage {
                delegate?.searchStorageHasBeenCreated(storage)
            }
        }
    }
    
    private func searchStorage(fromStorage: Storage, searchString: String, scope: Int) -> Storage? {
        
        let searchStorage = Storage()
        searchStorage.type = .search
        
        searchStorage.update({ (controller) in
            
            fromStorage.sections().enumerated().forEach({ (index, item) in
                let filtered = item.objects.filter({ (model) in
                    if let evaluation = model.searchEvaluation {
                        return evaluation(searchString, scope)
                    }
                    return false
                })
                controller.add(filtered, to: index)
            })
        })
        
        return searchStorage
    }
}

extension SearchManager: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(searchText, scope: searchBar.selectedScopeButtonIndex, shoudReload: false)
    }
    
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterItems(searchBar.text, scope: selectedScope, shoudReload: false)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        filterItems(nil, scope: SearchManager.searchScopeNone, shoudReload: false)
        searchBar.text?.removeAll()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
