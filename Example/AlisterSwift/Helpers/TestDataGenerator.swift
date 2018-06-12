//
//  TestDataGenerator.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 06.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit

class TestDataGenerator {
    
    private static let numberOfCarsToCreate = 20
    private static let carMakes = ["Ford", "Mazda", "Toyota", "Lexus", "Volvo", "Chevrolet", "Audi", "BMW"]
    
    static func carModels() -> [CarCellViewModel] {
        var cars: [Car] = []
        
        for _ in 0..<numberOfCarsToCreate {
            let cylinders = cylindersQuantity(Int(arc4random_uniform(4)))
            let carMakeIndex = Int(arc4random_uniform(6))
            let carMake = carMakes[carMakeIndex]
            let car = Car(make: carMake, cylindersQuantity: cylinders)
            cars.append(car)
        }
        
        return cars.map { return CarCellViewModel($0) }
    }
    
    // V4, V6, V8, V12
    private static func cylindersQuantity(_ num: Int) -> Int {
        switch num {
        case 0:
            return 4
        case 1:
            return 6
        case 2:
            return 8
        default:
            return 12
        }
    }
}
