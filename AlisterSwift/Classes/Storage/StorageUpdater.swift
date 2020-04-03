//
//  StorageUpdater.swift
//  Alister-Example
//
//  Created by Oksana Kovalchuk on 6/1/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit

/**
 
 This is a private class. You shouldn't use it directly in your code.
 ANStorageUpdater generates micro-transactions based on storage model updates.
 Also it handles all possible invalid arguments situations like nil values,
 or NSNotFound indexes to avoid crash and freezes.
 
 */

protocol StorageUpdaterInterface {
    
    var updateDelegate: StorageUpdateOperationInterface? { get }
    
    //TODO: doc
    func addSection(at index: Int)

    
    /**
     Adds item to section at zero index.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param item  to add. If value is nil empty update will be generated
     */
    
    func add(_ item: ViewModelInterface)
    
    
    /**
     Adds item to the specified section. If section index higher than existing sections count,
     all non-existing sections will be generated with empty rows array.
     Item will be appended to current items array.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param item          to add in storage
     @param sectionIndex  section to add item.
     */
    
    func add(_ item: ViewModelInterface, to: Int)
    
    
    /**
     Adds array of items to the zero section. If section index higher than existing sections count,
     all non-existing sections will be generated with empty rows array.
     Items will be appended to current items array.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param items NSArray* of items to insert in specified storage
     */
    
    func add(_ items: [ViewModelInterface])
    
    
    /**
     Adds array of items to the specified section. If section index higher than existing sections count,
     all non-existing sections will be generated with empty rows array.
     Items will be appended to current items array.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param items         NSArray* of items to insert in specified storage
     @param sectionIndex  index for section where items should be added
     */
    
    func add(_ items: [ViewModelInterface], to: Int)
    
    
    /**
     Adds item to the specified indexPath in storage. If row higher that existed count of
     objects in section, update will be ignored.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param item      to add in storage
     @param indexPath for item in storage after update
     */
    
    func add(_ item: ViewModelInterface, at: IndexPath)
    
    func add(_ items: [ViewModelInterface], at paths: [IndexPath])
    
    
    /**
     Replaces specified item with new one.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param itemToReplace item to replace, old existing item should be in storage already
     @param replacingItem new item, on which old item should be replaced
     */
    
    func replace<T: Equatable & ViewModelInterface>(_ item: T, with: ViewModelInterface)
    
    func replace(_ index: Int, on items: [ViewModelInterface])
    
    
    /**
     This method specially to pair UITableView's method:
     - (void)moveRowAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*)newIndexPath
     
     @param fromIndexPath from which indexPath item should removed
     @param toIndexPath   to which indexPath item should be inserted
     */
    
    
    func moveWithoutUpdate(from: IndexPath, to: IndexPath)
    
    
    
    /**
     Moves item on specified indexPath to new indexPath.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param fromIndexPath NSIndexPath* to get item from. If there is no item at this indexPath operation will be terminated.
     @param toIndexPath   NSIndexPath* new place for item. If there is no section for indexPath.section it will be generated. If in thi section number of items less than specified indexPath.row operation will be ternimated.
     */
    
    func move(from: IndexPath, to: IndexPath)
    
    
    /**
     Reloads specified item.
     You need this method when your item still the same, but it's content was updated.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     @param item    to reload
     */
    
    func reload<T: Equatable>(_ item: T)
    
    
    /**
     Reloads specified items array in storage.
     You need this method when your item objects are still the same, but their content was updated.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     
     @param items   NSArray* items array for reload
     */
    func reload<T: Equatable>(_ items: [T])
    
    func reload(_ index: Int)
    func reload(_ sections: [Int])
    
    
    /**
     Convention method for tables to register header model.
     You need to update headerKind property on storageModel before any updates
     
     @param headerModel  viewModel for header
     @param sectionIndex section index in UITableView
     */
    
    func update(headerModel: ViewModelInterface, section: Int)
    
    
    /**
     Convention method for tables to register footer model
     You need to update footerKind property on storageModel before any updates
     
     @param footerModel  viewModel for footer
     @param sectionIndex section index in UITableView
     */
    func update(footerModel: ViewModelInterface, section: Int)
}

struct StorageUpdater: StorageUpdaterInterface {
    
    var updateDelegate: StorageUpdateOperationInterface? = nil
    private var storageModel: StorageModel
    
    init(model: StorageModel) {
        storageModel = model
    }
    
    //TODO: unit test
    func addSection(at index: Int) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }

        let set = insertSection(at: index)
        update.addInsertedSectionIndexes(set)
    }
    
    func add(_ item: ViewModelInterface) {
        add([item], to: 0)
    }
    
    func add(_ items: [ViewModelInterface]) {
        add(items, to: 0)
    }
    
    func add(_ item: ViewModelInterface, to section: Int) {
        add([item], to: section)
    }
    
    func add(_ items: [ViewModelInterface], to section: Int) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        if items.count > 0, section >= 0 {
            let insertedSections = createSectionIfNotExist(section)
            let sectionModel = StorageLoader.section(at: section, storage: storageModel) //TODO: remove optional
            var numberOfItems = sectionModel?.numberOfObjects ?? 0
            var indexPaths: [IndexPath] = []
            
            for item in items {
                sectionModel?.add(item)
                indexPaths.append(IndexPath(row: numberOfItems, section: section))
                numberOfItems += 1
            }
            
            update.addInsertedSectionIndexes(insertedSections)
            update.addInsertedIndexPaths(indexPaths)
        }
    }
    
    func add(_ item: ViewModelInterface, at indexPath: IndexPath) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        let insertedSections = createSectionIfNotExist(indexPath.section)
        let sectionModel = StorageLoader.section(at: indexPath.section, storage: storageModel) //TODO: remove optional
        let numberOfItems = sectionModel?.numberOfObjects ?? 0
        
        if numberOfItems < indexPath.row {
            // TODO: throw ex
        } else {
            sectionModel?.insert(item, at: indexPath.row)
            update.addInsertedSectionIndexes(insertedSections)
            update.addInsertedIndexPaths([indexPath])
        }
    }
    
    func add(_ items: [ViewModelInterface], at paths: [IndexPath]) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        guard let sectionIndex = paths.first?.section else { return }
        let insertedSections = createSectionIfNotExist(sectionIndex)
        
        let sectionModel = StorageLoader.section(at: sectionIndex, storage: storageModel) //TODO: remove optional
        
        for path in paths.enumerated() {
            sectionModel?.insert(items[path.offset], at: path.element.row)
        }
        
        update.addInsertedSectionIndexes(insertedSections)
        update.addInsertedIndexPaths(paths)
    }
    
    func replace<T>(_ item: T, with newItem: ViewModelInterface) where T : ViewModelInterface & Equatable {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        if let originalIndexPath = StorageLoader.indexPath(for: item, storage: storageModel) {
            
            let section = StorageLoader.section(at: originalIndexPath.section, storage: storageModel)
            section?.replace(originalIndexPath.row, with: newItem)
            update.addUpdatedIndexPaths([originalIndexPath])
        }
    }
    
    func replace(_ index: Int, on items: [ViewModelInterface]) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        if let section = StorageLoader.section(at: index, storage: storageModel) {
            section.items = items
            update.addUpdatedSectionIndex(index)
        }
    }
    
    func moveWithoutUpdate(from: IndexPath, to: IndexPath) {
        move(from: from, to: to, handleUpdate: false)
    }
    
    func move(from: IndexPath, to: IndexPath) {
        move(from: from, to: to, handleUpdate: true)
    }
    
    func reload<T>(_ item: T) where T : Equatable {
        reload([item])
    }
    
    func reload<T>(_ items: [T]) where T : Equatable {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        let indexPaths = StorageLoader.indexPaths(for: items, storage: storageModel)
        update.addUpdatedIndexPaths(indexPaths)
    }
    
    func reload(_ index: Int) {
        reload([index])
    }
    
    func reload(_ sections: [Int]) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        for index in sections {
            if StorageLoader.section(at: index, storage: storageModel) != nil {
                update.addUpdatedSectionIndex(index)
            }
        }
    }
    
    func update(headerModel: ViewModelInterface, section: Int) {
        updateSupplementary(kind: storageModel.headerKind, section: section, model: headerModel)
    }
    
    func update(footerModel: ViewModelInterface, section: Int) {
        updateSupplementary(kind: storageModel.footerKind, section: section, model: footerModel)
    }
    
    
    //MARK: - Private
    
    private func move(from: IndexPath, to: IndexPath, handleUpdate: Bool = true) {
        var update = StorageUpdateModel();
        defer {
            if handleUpdate == true {
                updateDelegate?.collect(update)
            }
        }
        
        guard let item = StorageLoader.item(at: from, storage: storageModel) else {
            return
        }
        
        
        let fromSection = StorageLoader.section(at: from.section, storage: storageModel)
        
        var toSection = StorageLoader.section(at: to.section, storage: storageModel)
        //TODO: prichesat'
        if toSection != nil {
            
        } else if to.row == 0 { //if we can satisfy move action with created section
            let insertedSections = createSectionIfNotExist(to.section)
            update.addInsertedSectionIndexes(insertedSections)
            
            toSection = StorageLoader.section(at: to.section, storage: storageModel)
        } else {
            //do nothing
            return
        }
        
        fromSection?.remove(from.row)
        toSection?.insert(item, at: to.row)
        
        let movedIP = MovedIndexPath(from: from, to: to)
        update.addMovedIndexPaths([movedIP])
    }
    
    /**
     Generates empty sections to match count with specified index.
     Sends to delegate UpdateModel that contains diff for current operation.
     If operation was terminated update will be empty.
     @param sectionIndex section index up to what all section should be created
     @return IndexSet* that contains indexes of all creted sections.
     */
    private func createSectionIfNotExist(_ section: Int) -> IndexSet {
        var insertedIndexes = IndexSet()
        
        guard section >= storageModel.numberOfSections else {
            return insertedIndexes
        }
        
        for index in (storageModel.numberOfSections)...section {
            storageModel.addSection(SectionModel())
            insertedIndexes.update(with: index)
        }
        return insertedIndexes
    }
    
    //TODO: unit test
    private func insertSection(at index: Int) -> IndexSet {
        var insertedIndexes = IndexSet()
        
        storageModel.addSection(SectionModel())
        insertedIndexes.update(with: index)
        return insertedIndexes
    }
    
    private func updateSupplementary(kind: String, section: Int, model: ViewModelInterface) {
        var update = StorageUpdateModel(); defer { updateDelegate?.collect(update) }
        
        guard section >= 0 else { return }
        
        let createdSections = createSectionIfNotExist(section)
        let sectionToUpdate = StorageLoader.section(at: section, storage: storageModel)
        
        if StorageLoader.supplementary(kind: kind, section: section, storage: storageModel) != nil {
            update.addUpdatedSectionIndex(section)
        } else {
            // if section already exists, than inserted index does not exist, so we need to update section
            if createdSections.count == 0 {
                update.addUpdatedSectionIndex(section)
            } else {
                update.addInsertedSectionIndexes(createdSections)
            }
        }
        sectionToUpdate?.updateSupplementary(model, kind: kind)
    }
}
