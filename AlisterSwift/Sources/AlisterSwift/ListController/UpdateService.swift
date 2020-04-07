//
//  UpdateService.swift
//  AlisterSwift
//
//  Created by Oksana Kovalchuk on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

protocol StorageUpdateEventsDelegate: class {
    func storageDidPerformUpdate(_ updateOperation: StorageUpdateOperation, storageID: String, shouldAnimate: Bool)
    func storageNeedsReload(storageID: String, shouldAnimate: Bool)
}

class UpdateService: NSObject, StorageUpdateEventsDelegate {
    
    var listView: ListViewInterface
    weak var delegate: ListControllerUpdateServiceDelegate?
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue.main
        queue.maxConcurrentOperationCount = 1
        queue.addObserver(self, forKeyPath: #keyPath(OperationQueue.operations), options: .new, context: nil)
        return queue
    }()
    
    init(listView: ListViewInterface) {
        self.listView = listView
        super.init()
    }
    
    deinit {
        queue.removeObserver(self, forKeyPath: #keyPath(OperationQueue.operations))
    }
    
    func storageDidPerformUpdate(_ updateOperation: StorageUpdateOperation,
                                 storageID: String,
                                 shouldAnimate: Bool) {
        
        let controllerOperation = ListControllerUpdateOperation()
        controllerOperation.delegate = self
        controllerOperation.name = storageID
        controllerOperation.shouldAnimate = shouldAnimate
        
        updateOperation.controllerOperationDelegate = controllerOperation
        add(updateOperation: updateOperation, identifier: storageID)
        queue.addOperation(controllerOperation)
    }
    
    func storageNeedsReload(storageID: String, shouldAnimate: Bool) {
        reloadStorage(animated: shouldAnimate, identifier: storageID)
    }
    
//    MARK: - Private Methods
    private func add(updateOperation: StorageUpdateOperation, identifier: String) {
        updateOperation.updaterDelegate = self
        updateOperation.name = identifier
        queue.addOperation(updateOperation)
    }
    
    private func reloadStorage(animated: Bool, identifier: String) {
        
        if let operation = queue.operations.filter({ $0 is ListControllerUpdateOperation || $0 is ListControllerReloadOperation })
            .first(where: { $0.name == identifier }) {
            operation.cancel()
        }
        
        let controllerOperation = ListControllerReloadOperation()
        controllerOperation.delegate = self
        controllerOperation.name = identifier
        controllerOperation.shouldAnimate = animated
        queue.addOperation(controllerOperation)
    }
    
    // MARK: - KVO -
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let observedQueue = object as? OperationQueue, observedQueue === queue,
            keyPath == #keyPath(OperationQueue.operations) else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                return
        }
        guard queue.operations.isEmpty else { return }
        delegate?.allUpdatesFinished()
    }
}

extension UpdateService: ListControllerUpdateServiceInterface {
    func performListViewUpdate(_ update: StorageUpdateModel, animated: Bool) {
       listView.performUpdate(update, animated: animated)
    }
    
    func performListViewReload(animated: Bool) {
        listView.reloadData(animated: animated)
    }
    
    func storageNeedsReload(_ identifier: String, isAnimated: Bool) {
        reloadStorage(animated: isAnimated, identifier: identifier)
    }
}

