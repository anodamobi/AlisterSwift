//
//  ANListControllerUpdateOperation.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import QuartzCore

class ListControllerUpdateOperation: Operation, StorageListUpdateOperationInterface {
    
    weak var delegate: ListControllerUpdateServiceInterface?
    var shouldAnimate: Bool = false
    
    private var updateModel: StorageUpdateModel?
    
    private var _isExecuting  = false
    private var _isFinished  = false
    
    override var isFinished: Bool {
        get {
            return _isFinished
        }
        set {
            if newValue != _isFinished {
                willChangeValue(for: \.isFinished)
                _isFinished = newValue
                didChangeValue(for: \.isFinished)
            }
        }
    }
    
    override var isExecuting: Bool {
        get {
            return _isExecuting
        }
        set {
            if newValue != _isExecuting {
                willChangeValue(for: \.isExecuting)
                _isExecuting  = newValue
                didChangeValue(for: \.isExecuting)
            }
        }
    }
    
    // MARK: StorageUpdateTableOperationDelegate
    
    func updateGenerated(_ update: StorageUpdateModel) {
        updateModel = update
    }
    
    override func start() {
        if (isCancelled) {
            finishOp()
        } else {
            isExecuting = true
            main()
        }
    }
    
    override func main() {
        isExecuting = true
        if (!self.isCancelled) {
            if let model = self.updateModel, model.isEmpty() == false {
                self.performAnimatedUpdate(model)
            } else {
                finishOp()
            }
        }
    }
    
    // MARK: Private methods
    
    private func performAnimatedUpdate(_ update: StorageUpdateModel) {
        
        if update.isRequireReload() == false, shouldAnimate == true {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [unowned self] in
                self.finishOp()
            }
            delegate?.performListViewUpdate(update, animated: true)
            CATransaction.commit()
        } else {
            finishOp()
            guard let name = name else {
                assert(false, "storageID should not be empty")
                return
            }
            delegate?.storageNeedsReload(name, isAnimated: false)
        }
    }
    
    private func finishOp() {
        isFinished = true
        isExecuting = false
    }
}
