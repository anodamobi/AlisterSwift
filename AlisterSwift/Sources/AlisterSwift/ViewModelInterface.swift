//
//  ViewModelInterface.swift
//  Alister-Example
//
//  Created by Oksana Kovalchuk on 6/5/18.
//  Copyright © 2018 Oksana Kovalchuk. All rights reserved.
//

import Foundation
import UIKit

public typealias SearchEval = ((String, Int) -> Bool)
public typealias Selection = () -> ()

public protocol ViewModelInterface {
    
    var itemSize: CGSize? { get }
    
    var searchEvaluation: SearchEval? { get }
    var selection: Selection? { get }
}

public extension ViewModelInterface {
    
    var itemSize: CGSize? {
        return nil
    }
    
    var searchEvaluation: SearchEval? {
        return nil
    }
    
    var selection: Selection? {
        return nil
    }
}
