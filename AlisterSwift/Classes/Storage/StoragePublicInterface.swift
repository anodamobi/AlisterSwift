//
//  StoragePublicInterface.swift
//  Alister-Example
//
//  Created by Oksana Kovalchuk on 6/1/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation

/**
 This is public convention protocol to retrive items from storage
 */

protocol StorageRetrivingInterface  {
    
    /**
     Returns does storage contain items or not.
     !important Storage is empty if it has no rows, but it can has sections and be empty.
     @return BOOL is storage contain items
     */
    func isEmpty() -> Bool
    
    /**
     Returns all sections from storage including empty
     @return NSArray of ANStorageSectionModel* with all sections from storage
     */
    func sections() -> [SectionModel]
    
    /**
     Returns specified object from storage. Can be nil if index path is not exist in storage
     @param indexPath for item in storage
     @return item by indexPath
     */
    func object(at: IndexPath) -> ViewModelInterface?
    
    /**
     Returns specified section
     @param sectionIndex to retrive from storage
     @return ANStorageSectionModel* from storage
     */
    func section(at: Int) -> SectionModel?
    
    /**
     Returns all items from specified section
     Can be nil if section is not exist ot empty if no items there.
     @param sectionIndex for load items
     @return NSArray* from specified section
     */
    func itemsIn(section: Int) -> [ViewModelInterface]
    
    /**
     Returns indexPath for item in storage. Will return nil if item not found
     @param item item in storage, can be nit but then method will return nil immidiately
     @return indexPath* for item in stirage
     */
    func indexPath<T: ViewModelInterface & Equatable>(for: T) -> IndexPath?
    
    /**
     Convention method for UITableView to retrieve header viewModel specified for section.
     Can be nil if not set or section is not exist
     @param index section index to retrive header viewModel
     @return specified viewModel from storage
     */
    func headerModel(section: Int) -> ViewModelInterface?
    
    /**
     Convention method for UITableView to retrieve footer viewModel specified for section.
     Can be nil if not set or section is not exist
     @param index section index to retrive footer viewModel
     @return specified viewModel from storage
     */
    func footerModel(section: Int) -> ViewModelInterface?
    
    /**
     Convention method for UICollectionView to retrieve it supplementaty viewModels
     Can be nil if section not exist or supplementary was never set
     @param kind         supplementary kind from UICollectionView
     @param sectionIndex for section where this viewModel should be found
     @return viewModel from storage
     */
    func supplementaryModel(kind: String, section: Int) -> ViewModelInterface?
    
    func headerKind() -> String
    func footerKind() -> String
}

protocol StoragePublicInterface: StorageRetrivingInterface {
    
    /**
     This is a private property and should not call directly.
     */
    var updatesHandler: StorageUpdateEventsDelegate? { get set }
    
    /**
     This is a private property and should not call directly.
     Unique storage identifier. It installs while creating storage.
     */
    //    var storageID: String { get }
    
    /**
     Updates storage and list view with animation.
     
     @param block           Updates block. Contains storage controller, which conform <ANStorageUpdatableInterface>
     */
    func animatableUpdate(_ block: @escaping StorageUpdateClosure)
    
    /**
     Updates storage and list view without animation.
     
     @param block           Updates block. Contains storage controller, which conform <ANStorageUpdatableInterface>
     */
    func update(_ block: @escaping StorageUpdateClosure)
    
    /**
     Reloads storage and as result a list view.
     
     @param isAnimatable    Animation flag. YES, if you want to animate reloading.
     */
    func reload(shouldAnimate: Bool)
    
    func update(headerKind: String, footerKind: String)
}


