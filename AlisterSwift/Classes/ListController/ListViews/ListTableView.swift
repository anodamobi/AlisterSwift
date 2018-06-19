//
//  ListTableView.swift
//  Alister
//
//  Created by Maxim Danilov on 5/31/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit

class ListTableView {
    
    static private let listDefaultHeaderKind = "StorageHeaderKind"
    static private let listDefaultFooterKind = "StorageFooterKind"
    
    weak private var tableView: UITableView?
    var configModel: TableUpdateConfigurationModel = TableUpdateConfigurationModel()
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
}

// MARK: - ListViewInterface -
extension ListTableView: ListViewInterface {

    func registerSupplementaryClass(_ supplementaryClass: AnyClass,
                                    reuseIdentifier: String, kind: String) {
        guard supplementaryClass is UIView.Type else {
            assert(false, "❌ supplementaryClass type is incorrect")
            return
        }
        tableView?.register(supplementaryClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    func registerCellClass(_ cellClass: AnyClass, forReuseIdentifier identifier: String) {
        guard cellClass is UITableViewCell.Type else {
            assert(false, "❌ cellClass type is incorrect")
            return
        }
        tableView?.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func cell(identifier: String, at: IndexPath) -> ReusableViewInterface? {
        return tableView?.dequeueReusableCell(withIdentifier: identifier, for: at) as? ReusableViewInterface
    }
    
    func supplementaryView(identifier: String, kind: String, at: IndexPath?) -> ReusableViewInterface? {
        return tableView?.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? ReusableViewInterface
    }
    
    //TODO: check optional
    var scrollView: UIScrollView? {
        return tableView
    }
    
    func reloadData() {
        tableView?.reloadData()
    }
    
    var dataSource: AnyObject? {
        get {
            return tableView?.dataSource
        }
        set {
            guard newValue != nil else {
                tableView?.dataSource = nil
                return
            }
            guard let newValue = newValue as? UITableViewDataSource else {
                assert(false, "❌ dataSource must be UITableViewDataSource")
                return
            }
            tableView?.dataSource = newValue
        }
    }
    
    var delegate: AnyObject? {
        get {
            return tableView?.delegate
        }
        set {
            guard newValue != nil else {
                tableView?.delegate = nil
                return
            }
            guard let newValue = newValue as? UITableViewDelegate else {
                assert(false, "❌ dataSource must be UITableViewDelegate")
                return
            }
            tableView?.delegate = newValue
        }
    }
    
    var defaultHeaderKind: String {
        return ListTableView.listDefaultHeaderKind
    }
    
    var defaultFooterKind: String {
        return ListTableView.listDefaultFooterKind
    }
    
    var animationKey: String {
        return kCATransition //"UITableViewReloadDataAnimationKey"
    }
    
    func performUpdate(_ update: StorageUpdateModel, animated: Bool) {
        
        let animationConfigModel = animated ? configModel : TableUpdateConfigurationModel()
        var updatedSectionIndexes = update.updatedSectionIndexes
        let excludedSectionIndexes = update.insertedSectionIndexes.union(update.deletedSectionIndexes)
        updatedSectionIndexes.subtract(excludedSectionIndexes)
        
        tableView?.beginUpdates()
        tableView?.insertSections(update.insertedSectionIndexes, with: animationConfigModel.insertSectionAnimation)
        tableView?.deleteSections(update.deletedSectionIndexes, with: animationConfigModel.deleteSectionAnimation)
        tableView?.reloadSections(updatedSectionIndexes, with: animationConfigModel.reloadSectionAnimation)
        update.movedRowsIndexPaths.forEach { movedIndexPathsModel in
            if !update.deletedSectionIndexes.contains(movedIndexPathsModel.from.section) {
                tableView?.moveRow(at: movedIndexPathsModel.from, to: movedIndexPathsModel.to)
            }
        }
        
        tableView?.insertRows(at: Array(update.insertedRowIndexPaths), with: animationConfigModel.insertRowAnimation)
        tableView?.deleteRows(at: Array(update.deletedRowIndexPaths), with: animationConfigModel.deleteRowAnimation)
        tableView?.reloadRows(at: Array(update.updatedRowIndexPaths), with: animationConfigModel.reloadRowAnimation)
        tableView?.endUpdates()
    }
}
