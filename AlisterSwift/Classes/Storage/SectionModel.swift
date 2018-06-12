//
//  SectionModel.swift
//  ANODA-Alister-iOS8.0
//
//  Created by Oksana Kovalchuk on 5/30/18.
//

import Foundation

/**
 Private class to store section objects in memory.
 You should not call this call directly.
 */
protocol SectionModelInterface {
    
    /**
     Array of all objects in this section
     */
    
    var objects: [ViewModelInterface] { get }
    
    /**
     Dictionary with supplementaries (headers, footers) models and kinds
     */
    
    var supplementaryObjects: [String: ViewModelInterface] { get }
    
    
    /**
     Adds new item in the end of objects array
     
     @param item to add. If item will be nil no expection will be generated.
     */
    func add(_ item: ViewModelInterface)
    
    
    /**
     Inserts item at the specified index. If index is out of bounds or item is nil operation will skipped.
     
     @param item  item to add in storage
     @param index for item in the existing objects array
     */
    func insert(_ item: ViewModelInterface, at: Int)
    
    
    /**
     Removes item at specified index. If section not exist n
     
     @param index section index to remove
     */
    
    func remove(_ index: Int)
    
    
    /**
     Replaces item at specified index on a new item.
     If item at specified index not esists or new item is nil operation will be skipped.
     
     @param index index for item to replace
     @param item  new item to insert
     */
    func replace(_ at: Int, with: ViewModelInterface)
    
    
    func supplementaryModel(_ kind: String) -> ViewModelInterface?
    func removeSupplementary(kind: String)
    
    func replaceSupplementary(_ kind: String, on: String)
}


public class SectionModel: SectionModelInterface {
    
    var objects: [ViewModelInterface] {
        get {
            return items
        }
    }
    
    var numberOfObjects: Int {
        get {
            return items.count
        }
    }
    
    var supplementaryObjects: [String : ViewModelInterface] = [:]
    var items: [ViewModelInterface]

    init(items: [ViewModelInterface] = []) {
        self.items = items
    }
    
    func add(_ item: ViewModelInterface) {
        items.append(item)
    }
    
    func insert(_ item: ViewModelInterface, at index: Int) {
        if index <= items.endIndex {
            items.insert(item, at: index)
        }
    }
    
    func remove(_ index: Int) {
        if index < items.count {
            items.remove(at: index)
        }
    }
    
    func replace(_ index: Int, with element: ViewModelInterface) {
        items[index] = element
    }
    
    func replaceSupplementary(_ oldKind: String, on newKind: String) {
        if let value = supplementaryObjects[oldKind] {
            supplementaryObjects.removeValue(forKey: oldKind)
            supplementaryObjects[newKind] = value
        }
    }

    func updateSupplementary(_ model: ViewModelInterface, kind: String) {
        supplementaryObjects[kind] = model
    }
    
    func removeSupplementary(kind: String) {
        supplementaryObjects.removeValue(forKey: kind)
    }

    func supplementaryModel(_ kind: String) -> ViewModelInterface? {
        return supplementaryObjects[kind]
    }
}
