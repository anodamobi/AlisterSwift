//
//  StorageUpdateModel.swift
//  ANODA-Alister-iOS8.0
//
//  Created by Oksana Kovalchuk on 5/30/18.
//

import Foundation

protocol StorageUpdateInterface {
    
    /**
     Returns all deleted section indexes
     @return deleted sections indexSet
     */
    
    var deletedSectionIndexes: IndexSet { get }
    
    /**
     Returns all inserted section indexes
     @return inserted sections indexSet
     */
    var insertedSectionIndexes: IndexSet { get }
    
    /**
     Returns all updated section indexes
     @return updated sections indexSet
     */
    var updatedSectionIndexes: IndexSet { get }
    
    /**
     Returns array of deleted indexPaths
     @return NSSet* deleted indexPaths
     */
    var deletedRowIndexPaths: Set<IndexPath> { get }
    
    /**
     Returns array of inserted indexPaths
     @return NSSet* inserted indexPaths
     */
    var insertedRowIndexPaths: Set<IndexPath> { get }
    
    /**
     Returns array of updated indexPaths
     @return NSSet* updated indexPaths
     */
    var updatedRowIndexPaths: Set<IndexPath> { get }
    
    /**
     Returns array of moved indexPaths
     @return NSSet* moved indexPaths
     */
    var movedRowsIndexPaths: Set<MovedIndexPath> { get }
    
    /**
     Adds new index in a specified IndexSet
     @param index index to add
     */
    
    mutating func addDeletedSectionIndex(_ index: Int)
    
    /**
     Adds new index in a specified IndexSet
     @param index index to add
     */
    mutating func addUpdatedSectionIndex(_ index: Int)
    
    
    /**
     Adds new index in a specified IndexSet
     @param index index to add
     */
    mutating func addInsertedSectionIndex(_ index: Int)
    
    /**
     Adds new indexes from indexSet to a inserted IndexSet
     @param indexSet indexes to add
     */
    mutating func addInsertedSectionIndexes(_ index: IndexSet)
    
    /**
     Adds new indexes from indexSet to a updated IndexSet
     @param indexSet indexes to add
     */
    mutating func addUpdatedSectionIndexes(_ index: IndexSet)
    
    /**
     Adds new indexes from indexSet to a deleted IndexSet
     @param indexSet indexes to add
     */
    mutating func addDeletedSectionIndexes(_ index: IndexSet)
    
    /**
     Adds new indexPaths to existing property
     @param items NSArray* with inserted indexPaths. No update will happen if parameter is nil.
     */
    mutating func addInsertedIndexPaths(_ index: [IndexPath])
    
    /**
     Adds new indexPaths to existing property
     @param items NSArray* with updated indexPaths. No update will happen if parameter is nil.
     */
    mutating func addUpdatedIndexPaths(_ index: [IndexPath])
    
    /**
     Adds new indexPaths to existing property
     @param items NSArray* with deleted indexPaths. No update will happen if parameter is nil.
     */
    mutating func addDeletedIndexPaths(_ index: [IndexPath])
    
    /**
     Adds new indexPaths to existing property
     @param items NSArray* with moved indexPaths. No update will happen if parameter is nil.
     */
    mutating func addMovedIndexPaths(_ index: [MovedIndexPath])
    
    /**
     Indicates does storage got big update so now related TableView or CollectionView
     should be reloaded insted of applying updates.
     @return BOOL does require reload
     */
    func isRequireReload() -> Bool
}

struct StorageUpdateModel: StorageUpdateInterface, Equatable {
    
    var deletedSectionIndexes: IndexSet = []
    var insertedSectionIndexes: IndexSet = []
    var updatedSectionIndexes: IndexSet = []
    
    var deletedRowIndexPaths = Set<IndexPath>()
    var insertedRowIndexPaths = Set<IndexPath>()
    var updatedRowIndexPaths = Set<IndexPath>()
    var movedRowsIndexPaths = Set<MovedIndexPath>()
    
    var requiresReload: Bool = false
    
    func isEmpty() -> Bool {
        return  deletedSectionIndexes.isEmpty &&
            insertedSectionIndexes.isEmpty &&
            updatedSectionIndexes.isEmpty &&
            deletedRowIndexPaths.isEmpty &&
            insertedRowIndexPaths.isEmpty &&
            updatedRowIndexPaths.isEmpty &&
            movedRowsIndexPaths.isEmpty &&
            isRequireReload() == false
    }
    
    func isRequireReload() -> Bool {
        return requiresReload
    }
    
    mutating func merge(from: StorageUpdateModel) {
        addInsertedSectionIndexes(from.insertedSectionIndexes)
        addUpdatedSectionIndexes(from.updatedSectionIndexes)
        addDeletedSectionIndexes(from.deletedSectionIndexes)
        
        addInsertedIndexPaths(Array(from.insertedRowIndexPaths))
        addUpdatedIndexPaths(Array(from.updatedRowIndexPaths))
        addMovedIndexPaths(Array(from.movedRowsIndexPaths))
        addDeletedIndexPaths(Array(from.deletedRowIndexPaths))
        
        requiresReload = (from.requiresReload || requiresReload)
    }

    
    static func == (lhs: StorageUpdateModel, rhs: StorageUpdateModel) -> Bool {
        return  lhs.deletedSectionIndexes == rhs.deletedSectionIndexes &&
            lhs.updatedSectionIndexes == rhs.updatedSectionIndexes &&
            lhs.insertedSectionIndexes == rhs.insertedSectionIndexes &&
            lhs.deletedRowIndexPaths == rhs.deletedRowIndexPaths &&
            lhs.insertedRowIndexPaths == rhs.insertedRowIndexPaths &&
            lhs.movedRowsIndexPaths == rhs.movedRowsIndexPaths &&
            lhs.updatedRowIndexPaths == rhs.updatedRowIndexPaths &&
            lhs.requiresReload == rhs.requiresReload
    }
    
    mutating func addDeletedSectionIndex(_ index: Int) {
        deletedSectionIndexes.insert(index)
    }
    
    mutating func addUpdatedSectionIndex(_ index: Int) {
        updatedSectionIndexes.insert(index)
    }
    
    mutating func addInsertedSectionIndex(_ index: Int) {
        insertedSectionIndexes.insert(index)
    }
    
    
    mutating func addInsertedSectionIndexes(_ index: IndexSet) {
        insertedSectionIndexes.formUnion(index)
    }
    
    mutating func addDeletedSectionIndexes(_ index: IndexSet) {
        deletedSectionIndexes.formUnion(index)
    }
    
    mutating func addUpdatedSectionIndexes(_ index: IndexSet) {
        updatedSectionIndexes.formUnion(index)
    }
    
    mutating func addInsertedIndexPaths(_ index: [IndexPath]) {
        insertedRowIndexPaths.formUnion(index)
    }
    
    mutating func addUpdatedIndexPaths(_ index: [IndexPath]) {
        updatedRowIndexPaths.formUnion(index)
    }
    
    mutating func addDeletedIndexPaths(_ index: [IndexPath]) {
        deletedRowIndexPaths.formUnion(index)
    }
    
    mutating func addMovedIndexPaths(_ index: [MovedIndexPath]) {
        movedRowsIndexPaths.formUnion(index)
    }
}
