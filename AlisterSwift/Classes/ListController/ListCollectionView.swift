//
//  ListCollectionView.swift
//  Alister
//
//  Created by Simon Kostenko on 5/31/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit

class ListCollectionView: ListViewInterface {
    
    private weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func registerSupplementaryClass(_ supplementaryClass: AnyClass, reuseIdentifier: String, kind: String) {
        guard supplementaryClass is UIView.Type else {
            assert(false, "❌ supplementaryClass type is incorrect")
            return
        }
        collectionView?.register(supplementaryClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
    
    func registerCellClass(_ cellClass: AnyClass, forReuseIdentifier identifier: String) {
        guard cellClass is UICollectionViewCell.Type else {
            assert(false, "❌ cellClass type is incorrect")
            return
        }
        collectionView?.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func cell(identifier: String, at: IndexPath) -> ReusableViewInterface? {
        return collectionView?.dequeueReusableCell(withReuseIdentifier: identifier, for: at) as? ReusableViewInterface
    }
    
    func supplementaryView(identifier: String, kind: String, at: IndexPath?) -> ReusableViewInterface? {
        guard let indexPath = at else {
            assert(false, "indexPath is nil")
            return nil
        }
        
        return collectionView?.dequeueReusableSupplementaryView(ofKind: kind,
                                                                withReuseIdentifier: identifier,
                                                                for: indexPath) as? ReusableViewInterface
    }
    
    var scrollView: UIScrollView? {
        return collectionView
    }
    
    var dataSource: AnyObject? {
        get {
            return collectionView?.dataSource
        }
        set {
            guard newValue != nil else {
                collectionView?.dataSource = nil
                return
            }
            guard let newValue = newValue as? UICollectionViewDataSource else {
                assert(false, "❌ dataSource must be UICollectionViewDataSource")
                return
            }
            collectionView?.dataSource = newValue
        }
    }
    
    var delegate: AnyObject? {
        get {
            return collectionView?.delegate
        }
        set {
            guard newValue != nil else {
                collectionView?.delegate = nil
                return
            }
            guard let newValue = newValue as? UICollectionViewDelegate else {
                assert(false, "❌ dataSource must be UICollectionViewDelegate")
                return
            }
            collectionView?.delegate = newValue
        }
    }
    
    func reloadData() {
        collectionView?.reloadData()
    }
    
    var defaultHeaderKind: String {
        return UICollectionElementKindSectionHeader
    }
    
    var defaultFooterKind: String {
        return UICollectionElementKindSectionFooter
    }
    
    var animationKey: String {
        return "UICollectionViewReloadDataAnimationKey"
    }
    
    func performUpdate(_ update: StorageUpdateModel, animated: Bool) {
        var sectionsToInsert = IndexSet()
        
        for (index, _) in update.insertedSectionIndexes.enumerated() {
            guard let collectionView = collectionView else { return }
            
            if collectionView.numberOfSections <= index {
                sectionsToInsert.insert(index)
            }
        }
        
        var updatedSectionIndexes = update.updatedSectionIndexes
        updatedSectionIndexes.subtract(update.insertedSectionIndexes)
        updatedSectionIndexes.subtract(update.deletedSectionIndexes)
        
        let sectionChanges = update.deletedSectionIndexes.count +
            update.insertedSectionIndexes.count +
            update.updatedSectionIndexes.count
        
        let itemChanges = update.deletedRowIndexPaths.count +
            update.insertedRowIndexPaths.count +
            update.updatedRowIndexPaths.count
        
        if sectionChanges != 0 {
            collectionView?.performBatchUpdates({
                collectionView?.deleteSections(update.deletedSectionIndexes)
                collectionView?.insertSections(sectionsToInsert)
                collectionView?.reloadSections(updatedSectionIndexes)
            }, completion: nil)
        }
        
        if shouldReloadToPreventInsertFirstItemIssue(update: update) {
            reloadData()
            return
        }
        
        if itemChanges != 0 && sectionChanges == 0 {
            collectionView?.performBatchUpdates({
                collectionView?.deleteItems(at: Array(update.deletedRowIndexPaths))
                collectionView?.insertItems(at: Array(update.insertedRowIndexPaths))
                collectionView?.reloadItems(at: Array(update.updatedRowIndexPaths))
            }, completion: nil)
        }
    }
    
    private func shouldReloadToPreventInsertFirstItemIssue(update: StorageUpdateModel) -> Bool {
        
        for indexPath in update.insertedRowIndexPaths {
            if collectionView?.numberOfItems(inSection: indexPath.section) == 0 {
                return true
            }
        }
        
        for indexPath in update.deletedRowIndexPaths {
            if collectionView?.numberOfItems(inSection: indexPath.section) == 1 {
                return true
            }
        }
        
        if collectionView?.window == nil {
            return true
        }
        
        return false
    }
}

