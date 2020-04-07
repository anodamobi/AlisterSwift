//
//  Car.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 06.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

class Car {
    var make: String
    var cylindersQuantity: Int
    
    init(make: String, cylindersQuantity: Int) {
        self.make = make
        self.cylindersQuantity = cylindersQuantity
    }
}
