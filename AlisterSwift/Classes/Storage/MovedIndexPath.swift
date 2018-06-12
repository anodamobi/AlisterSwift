//
//  MovedIndexPath.swift
//  ANODA-Alister-iOS8.0
//
//  Created by Oksana Kovalchuk on 5/30/18.
//

import Foundation

protocol MovedIndexPathInterface {
    /**
     Indicates FROM which position item will be moved
     */
    var from: IndexPath { get set }
    
    /**
     Indicates TO which position item will be moved
     */
    var to: IndexPath { get set }
}

struct MovedIndexPath: MovedIndexPathInterface, Equatable, Hashable, CustomStringConvertible {
    var from: IndexPath
    var to: IndexPath
    
    var description: String {
        return "fromIndexPath: (\(from.section) - \(from.row)), toIndexPath: (\(to.section) - \(to.row))"
    }
    
    static func == (lhs: MovedIndexPath, rhs: MovedIndexPath) -> Bool {
        return lhs.from == rhs.from
            && lhs.to == rhs.to
    }
    
    public var hashValue: Int {
        return from.hashValue + to.hashValue
    }
}
