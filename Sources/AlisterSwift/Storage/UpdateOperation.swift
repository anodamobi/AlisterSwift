//
//  UpdateOperation.swift
//  ANODA-Alister-iOS8.0
//
//  Created by Oksana Kovalchuk on 5/31/18.
//

import Foundation

protocol StorageUpdateOperationInterface: class {
    func collect(_ update: StorageUpdateModel)
}

protocol StorageListUpdateOperationInterface: class {
    func updateGenerated(_ update: StorageUpdateModel)
}

typealias UpdateOperationConfigurationBlock = (StorageUpdateOperation) -> ()



class StorageUpdateOperation: Operation, StorageUpdateOperationInterface {
    
    weak var controllerOperationDelegate: StorageListUpdateOperationInterface?
    weak var updaterDelegate: StorageUpdateEventsDelegate? //TODO:
    
    private var updates: [StorageUpdateModel] = []
    private var configBlock: UpdateOperationConfigurationBlock
    
    init(_ config: @escaping UpdateOperationConfigurationBlock) {
        configBlock = config
    }
    
    override func main() {
        if isCancelled == false {
            configBlock(self)
        }
        let updateModel = mergeUpdates()
        if updateModel.isRequireReload() {
            updaterDelegate?.storageNeedsReload(storageID: name ?? "", shouldAnimate: false) //TODO: name optional
        } else {
            controllerOperationDelegate?.updateGenerated(updateModel)
        }
    }

    func collect(_ update: StorageUpdateModel) {
        if update.isEmpty() == false {
            updates.append(update)
        } else {
            debugPrint("update is empty or nil, skipped")
        }
    }
    
    private func mergeUpdates() -> StorageUpdateModel {
        var update = StorageUpdateModel()
        for item in updates {
            update.merge(from: item)
        }
        return update
    }
}
