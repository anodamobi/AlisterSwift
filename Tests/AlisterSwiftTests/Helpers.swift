//
//  Helpers.swift
//  AlisterSwiftTests
//
//  Created by Oksana Kovalchuk on 6/7/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit

@testable import AlisterSwift

extension StorageUpdateModel {
    
    static func empty() -> StorageUpdateModel {
        return StorageUpdateModel()
    }
    
    static func requiresReload() -> StorageUpdateModel {
        var model = StorageUpdateModel()
        model.requiresReload = true
        return model
    }
    
    static func someValuesInside() -> StorageUpdateModel {
        var model = StorageUpdateModel()
        model.addInsertedIndexPaths([IndexPath.init(row: 1, section: 1)])
        return model
    }
}

func randomObject() -> Any {
    let counter = arc4random_uniform(10)
    switch counter % 5 {
    case 0:  return NSObject()
    case 1:  return randomInt()
    case 2:  return randomString()
    case 3:  return [randomString(), randomInt()]
    default: return NSNull.init()
    }
}

func randomInt() -> Int {
    return Int(arc4random_uniform(10000))
}
func randomString() -> String {
    return UUID.init().uuidString
}

func randomClass() -> Any.Type {
    let counter = arc4random_uniform(1000) % 9
    switch counter {
    case 0: return type(of: "")
    case 1: return Int.self
    case 2: return IndexSet.self
    case 3: return IndexPath.self
    case 4: return type(of: ["123"])
    case 5: return type(of: ["var": 123])
    case 6: return NSObject.self
    case 7: return NSNull.self
    case 8: return NumberFormatter.self
    default: return IndexSet.self
    }
}

func randomArray() -> [Any] {
    let counter = Int(arc4random_uniform(1000) % 9)
    return randomArray(length: counter)
}

func randomArray(length: Int) -> [Any] {
    var result = [Any]()
    for _ in 0...length {
        result.append(randomObject())
    }
    return result
}

func randomArray(include element: Any, at index: Int) -> [Any] {
    var array = Array(randomArray(length: index * 2))
    array.insert(element, at: index)
    return array
}

func randomDict() -> [String: Any] {
    let counter = Int(arc4random_uniform(1000) % 9)
    var result = [String: Any]()
    for _ in 0...counter {
        result[randomString()] = randomObject()
    }
    return result
}

func zeroIndexPath() -> IndexPath {
    return IndexPath.init(row: 0, section: 0)
}


struct TestViewModel: ViewModelInterface, Equatable {
    var item: String
    
    static func == (lhs: TestViewModel, rhs: TestViewModel) -> Bool {
        return lhs.item == rhs.item
    }
}
