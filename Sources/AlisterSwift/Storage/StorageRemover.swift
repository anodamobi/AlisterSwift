//
//  StorageRemover.swift
//  Alister-Example
//
//  Created by Oksana Kovalchuk on 6/1/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation


/**
 
 This is a private class. You shouldn't use it directly in your code.
 ANStorageRemover generates micro-transactions based on storage model updates.
 Also it handles all possible invalid arguments situations like nil values,
 or NSNotFound indexes to avoid crash and freezes.
 
 */
protocol StorageRemoverInterface {
    
    /**
     Delegate for updates.
     */
    var updateDelegate: StorageUpdateOperationInterface? { get set }
    
    
    
    /**
     Removes specified item from storage.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param item    item to remove
     
     */
    func remove<T: Equatable>(_ item: T)
    
    
    /**
     Removes specified set of indexPaths from storage.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     @param indexPaths NSSet* of indexPaths which should be removed
     */
    
    func remove(_ items: [IndexPath])
    
    
    /**
     Removes specified set of items from storage.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param items   NSSet* of items which should be removed. Not tested if storage contains equal objects.
     */
    func remove<T: Equatable & ViewModelInterface>(_ items: [T])
    
    
    /**
     Removes specified set of section indexes from storage.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param indexSet NSIndexSet* of section indexes which you want to remove
     
     */
    
    func remove(sections: [Int])
    
    /**
     Removes all sections and all items in sections and restores initial state.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     */
    
    func removeAll()
    
    func removeSupplementary(kind: String, section: Int)
}

struct StorageRemover: StorageRemoverInterface {
    
    var updateDelegate: StorageUpdateOperationInterface? = nil
    var storage: StorageModel //???
    
    init(storageModel: StorageModel) {
        self.storage = storageModel
    }
    
    func remove<T>(_ item: T) where T : Equatable {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        if let indexPath = StorageLoader.indexPath(for: item, storage: storage) {
            let section = StorageLoader.section(at: indexPath.section, storage: storage)
            section?.remove(indexPath.row)
            update.addDeletedIndexPaths([indexPath])
        }
    }
    
    func remove(_ items: [IndexPath]) {
        // начинать тут нужно с жопы
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        let indexArray = items.sorted().reversed()
        
        for indexPath in indexArray {
            if StorageLoader.item(at: indexPath, storage: storage) != nil {
                let section = StorageLoader.section(at: indexPath.section, storage: storage)
                section?.remove(indexPath.row)
                update.addDeletedIndexPaths([indexPath])
            }
        }
    }
    
    func remove<T>(_ items: [T]) where T : ViewModelInterface, T : Equatable {
        var indexPaths: [IndexPath] = []
        items.enumerated().forEach { (index, item) in
            if let indexPath = StorageLoader.indexPath(for: item, storage: storage) {
                indexPaths.append(indexPath)
            }
        }
        remove(indexPaths)
    }
    
    func remove(sections: [Int]) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        //TODO: mutating
        storage.sections.enumerated().reversed().forEach { (index, section) in
            if sections.contains(index) {
                storage.removeSection(index)
                update.addDeletedSectionIndex(index)
            }
        }
    }
    
    func removeAll() {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        if storage.sections.count > 0 {
            storage.removeAllSections()
            update.requiresReload = true
        }
    }
    
    func removeSupplementary(kind: String, section index: Int) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        if let sectionToUpdate = StorageLoader.section(at: index, storage: storage) {
            sectionToUpdate.removeSupplementary(kind: kind)
            update.addUpdatedSectionIndex(index)
        }
    }
    
    func removeHeader(section index: Int) {
        removeSupplementary(kind: storage.headerKind, section: index)
    }
    
    func removeFooter(section index: Int) {
        removeSupplementary(kind: storage.footerKind, section: index)
    }
}
