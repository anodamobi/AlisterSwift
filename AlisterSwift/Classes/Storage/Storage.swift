//
//  Storage.swift
//  ANODA-Alister-iOS8.0
//
//  Created by Oksana Kovalchuk on 5/30/18.
//

import Foundation
import UIKit

typealias StorageUpdateClosure = (StorageUpdatableInterface)->()

public protocol StorageUpdatableInterface {
    
    func add(_ item: ViewModelInterface)
    func add(_ item: ViewModelInterface, to: Int)
    func add(_ item: ViewModelInterface, at: IndexPath)
    
    func add(_ items: [ViewModelInterface])
    func add(_ items: [ViewModelInterface], to: Int)

    func reload<T: ViewModelInterface & Equatable>(_ item: T)
    func reload<T: ViewModelInterface & Equatable>(_ items: [T])

    func remove<T: ViewModelInterface & Equatable>(_ item: T)
    func remove(_ at: IndexPath)
    func remove(_ at: [IndexPath])
    func remove<T: ViewModelInterface & Equatable>(_ items: [T])
    func removeAll()
    
    func replace<T: ViewModelInterface & Equatable>(_ item: T, on: ViewModelInterface)
    func move(from: IndexPath, to: IndexPath)
    
    func remove(_ sections: [Int])
    
    func update(headerModel: ViewModelInterface, section: Int)
    func update(footerModel: ViewModelInterface, section: Int)

    //collection view
    func updateHeader(supplementaryKind: String)
    func updateFooter(supplementaryKind: String)
    
    /**
     This method specially to pair UITableView's method:
     - (void)moveRowAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*)newIndexPath
     
     @param fromIndexPath from which indexPath item should removed
     @param toIndexPath   to which indexPath item should be inserted
     */
    
    func moveWithoutUpdate(from: IndexPath, to: IndexPath)
}

public class Storage: StoragePublicInterface, StorageUpdatableInterface {

    enum StorageType {
        case regular
        case search
    }
    
    var updatesHandler: StorageUpdateEventsDelegate?
    
    var type: StorageType = .regular
    var remover: StorageRemover
    var updater: StorageUpdater
    let storageID = UUID.init().uuidString
    
    /**
     Current storage model that contains all items
     */
    let storageModel = StorageModel()

    init() {
        remover = StorageRemover(storageModel: storageModel)
        updater = StorageUpdater(model: storageModel)
    }

    public func animatableUpdate(_ block: @escaping (StorageUpdatableInterface) -> ()) {
       update(shouldAnimate: true, block: block)
    }
    
    public func update(_ block: @escaping (StorageUpdatableInterface) -> ()) {
        update(shouldAnimate: false, block: block)
    }
    
    private func update(shouldAnimate: Bool = false, block: @escaping StorageUpdateClosure) {
        
        if type != .search {
            let updateOp = StorageUpdateOperation { op in
                self.updater.updateDelegate = op
                self.remover.updateDelegate = op
                block(self)
            }
            updateOp.name = storageID
            updatesHandler?.storageDidPerformUpdate(updateOp,
                                                    storageID: storageID,
                                                    shouldAnimate: shouldAnimate)
        } else {
            block(self)
        }
    }
    
    public func reload(shouldAnimate: Bool) {
        updatesHandler?.storageNeedsReload(storageID: storageID, shouldAnimate: shouldAnimate)
    }
    
    public func update(headerKind: String, footerKind: String) {
        updateHeader(supplementaryKind: headerKind)
        updateFooter(supplementaryKind: footerKind)
    }

    
    //MARK:- Retriving
    



    
    //MARK: - Add items
    
    public func add(_ item: ViewModelInterface) {
        updater.add([item], to: 0)
    }
    
    public func add(_ items: [ViewModelInterface]) {
        updater.add(items, to: 0)
    }
    
    public func add(_ item: ViewModelInterface, to section: Int) {
        updater.add([item], to: section)
    }
    
    public func add(_ items: [ViewModelInterface], to section: Int) {
        updater.add(items, to: section)
    }
    
    public func add(_ item: ViewModelInterface, at: IndexPath) {
        updater.add(item, at: at)
    }
    
    
    //MARK: - Reloading
    
    public func reload<T>(_ item: T) where T : ViewModelInterface & Equatable {
        updater.reload([item])
    }

    public func reload<T>(_ items: [T]) where T : ViewModelInterface & Equatable {
        updater.reload(items)
    }
    

    //MARK: - Removing
    
    public func remove(_ indexPath: IndexPath) {
        remover.remove([indexPath])
    }
    
    public func remove(_ indexPaths: [IndexPath]) {
        remover.remove(indexPaths)
    }
    
    public func remove<T>(_ item: T) where T : ViewModelInterface & Equatable {
        remover.remove(item)
    }
    
    public func remove(_ sections: [Int]) {
        remover.remove(sections: sections)
    }
    
    public func remove<T>(_ items: [T]) where T : ViewModelInterface & Equatable {
        remover.remove(items)
    }
    
    public func removeAll() {
        remover.removeAll()
    }
    
    
    //MARK: - Replacing / Moving
    
    public func replace<T>(_ item: T, on: ViewModelInterface) where T : ViewModelInterface & Equatable {
        updater.replace(item, with: on)
    }
    
    public func moveWithoutUpdate(from: IndexPath, to: IndexPath) {
        updater.moveWithoutUpdate(from: from, to: to)
    }
    
    public func move(from: IndexPath, to: IndexPath) {
        updater.move(from: from, to: to)
    }
    
    //MARK: - Supplementaries
    
    public func updateHeader(supplementaryKind: String) {
        storageModel.headerKind = supplementaryKind
    }
    
    public func updateFooter(supplementaryKind: String) {
        storageModel.footerKind = supplementaryKind
    }
    
    func headerKind() -> String {
        return storageModel.headerKind
    }
    
    func footerKind() -> String {
        return storageModel.footerKind
    }
    
    public func update(headerModel: ViewModelInterface, section: Int) {
        updater.update(headerModel: headerModel, section: section)
    }
    
    public func update(footerModel: ViewModelInterface, section: Int) {
        updater.update(footerModel: footerModel, section: section)
    }
    
    public func removeHeader(section: Int) {
        remover.removeHeader(section: section)
    }
    
    public func removeFooter(section: Int) {
        remover.removeFooter(section: section)
    }
    
    public func debugDescription() -> String {
        return "ID: \(storageID)\n" + storageModel.debugDescription()
    }
}

extension Storage: StorageRetrivingInterface {
    
    public func sections() -> [SectionModel] {
        return storageModel.sections
    }
    
    public func object(at: IndexPath) -> ViewModelInterface? {
        return StorageLoader.item(at: at, storage: storageModel)
    }
    
    public func allObjects() -> [ViewModelInterface] {
        return StorageLoader.allObjects(storage: storageModel)
    }
    
    public func section(at: Int) -> SectionModel? {
        return StorageLoader.section(at: at, storage: storageModel)
    }
    
    public func itemsIn(section: Int) -> [ViewModelInterface] {
        return StorageLoader.items(in: section, storage: storageModel)
    }
    
    public func indexPath<T>(for model: T) -> IndexPath? where T : ViewModelInterface & Equatable {
        return StorageLoader.indexPath(for: model, storage: storageModel)
    }
    
    public func isEmpty() -> Bool {
        return storageModel.isEmpty()
    }
    
    public func headerModel(section: Int) -> ViewModelInterface? {
        return StorageLoader.supplementary(kind: storageModel.headerKind, section: section, storage: storageModel)
    }
    
    public func footerModel(section: Int) -> ViewModelInterface? {
        return StorageLoader.supplementary(kind: storageModel.footerKind, section: section, storage: storageModel)
    }
    
    public func supplementaryModel(kind: String, section: Int) -> ViewModelInterface? {
        return StorageLoader.supplementary(kind: kind, section: section, storage: storageModel)
    }
}
