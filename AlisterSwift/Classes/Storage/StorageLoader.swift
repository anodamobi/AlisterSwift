//
//  StorageLoader.swift
//  Alister-Example
//
//  Created by Oksana Kovalchuk on 6/1/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation

protocol StorageLoaderInterface {
    
    /**
     Searches index path in specified storage and returns view model.
     
     @param indexPath       NSIndexPath for list view
     @param storage         for searching
     */
    
    static func item(at: IndexPath, storage: StorageModel) -> ViewModelInterface?
    
    
    /**
     Searches model in specified storage and returns index path.
     
     !!! or !!!
     Returns index path by specified view model in specified storage
     Returns index path by specified view model and searches it in specified storage
     
     @param item            in storage
     @param storage         for searching
     
     @return index path for view model
     */
    
    
    static func indexPath<T:Equatable>(for: T, storage: StorageModel) -> IndexPath?
    
    
    /**
     Returns array of view models by specified section index in storage.
     
     @param sectionIndex    for section to return
     @param storage         for searching
     
     @return view models by specified section
     */
    
    static func items(in: Int, storage: StorageModel) -> [ViewModelInterface]
    
    /**
     Returns array of view models in storage
     
     @param storage         for searching
     
     @return view models in storage
     */
    
    static func allObjects(storage: StorageModel) -> [ViewModelInterface]
    
    /**
     Returns array of index paths by specified view models in storage
     @param items           in storage
     @param storage         for searching
     @return array of index paths by specified view models
     */
    static func indexPaths<T:Equatable>(for: [T], storage: StorageModel) -> [IndexPath]
    
    
    /**
     Returns section model by specified section index in storage
     
     @param sectionIndex    in storage
     @param storage         for searching
     
     @return storage model by specified section index
     */
    
    static func section(at: Int, storage: StorageModel) -> SectionModel?
    
    
    /**
     Returns supplemetary model for specified section and with specified kind
     
     @param kind            for model
     @param sectionIndex    for section to return
     
     @return viewModel with specified kind
     */
    
    static func supplementary(kind: String, section: Int, storage: StorageModel) -> ViewModelInterface?
}


class StorageLoader: StorageLoaderInterface {
    
    static func indexPaths<T>(for items: [T], storage: StorageModel) -> [IndexPath] where T :  Equatable {
        var result: [IndexPath] = []
        
        for item in items {
            if let indexPath = indexPath(for: item, storage: storage) {
                result.append(indexPath)
            } else {
                debugPrint("ANStorage - \(item) not found")
            }
        }
        return result
    }
    
    static func indexPath<T>(for item: T, storage: StorageModel) -> IndexPath? where T : Equatable {
        var result: IndexPath? = nil
        
        storage.sections.enumerated().forEach { (sectionIndex, section) in
            
            section.objects.enumerated().forEach({ (rowIndex, row) in
                if let rowObject = row as? T, rowObject == item {
                    result = IndexPath(row: rowIndex, section: sectionIndex)
                }
            })
        }
        return result
    }
    
    static func allObjects(storage: StorageModel) -> [ViewModelInterface] {
        var result: [ViewModelInterface] = []
        let sections = storage.sections
        sections.forEach {
            result.append(contentsOf: $0.items)
        }
        return result
    }
    
    static func item(at: IndexPath, storage: StorageModel) -> ViewModelInterface? {
        return storage.itemAt(at)
    }
    
    static func items(in index: Int, storage: StorageModel) -> [ViewModelInterface] {
        return storage.sectionAt(index)?.objects ?? []
    }
    
    static func section(at: Int, storage: StorageModel) -> SectionModel? {
        return storage.sectionAt(at)
    }
    
    static func supplementary(kind: String, section: Int, storage: StorageModel) -> ViewModelInterface? {
        return storage.sectionAt(section)?.supplementaryModel(kind)
    }
}
