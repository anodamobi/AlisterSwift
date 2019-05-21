//
//  ANListControllerMappingServiceTests.swift
//  AlisterSwiftTests
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import Nimble
import Quick
@testable import AlisterSwift

class ViewModelExample: Hashable, ViewModelInterface {
    var id: String = ""
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // swiftlint:disable operator_whitespace
    static func ==(lhs: ViewModelExample, rhs: ViewModelExample) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListControllerMappingServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Mapping Service tests") {
            
            let service = ListControllerMappingService()
            let classIdentifier = String(describing: ViewModelExample.self)
            let fullClassIdentifier = classIdentifier + "<=>" + "kANDefaultCellKind"
            
            it("Register Class", closure: {
                let result = service.registerViewModelClass(ViewModelExample.self)
                expect(result) == fullClassIdentifier
            })
            
            it("Register Class custom kind", closure: {
                let result = service.registerViewModelClass(ViewModelExample.self, kind: "Hello_world")
                let expectedResult = classIdentifier + "<=>" + "Hello_world"
                expect(result) == expectedResult
            })
            
            it("Get registered identifier", closure: {
                _ = service.registerViewModelClass(ViewModelExample.self)
                let result = service.identifierForViewModelClass(ViewModelExample.self)
                expect(result).to(equal(fullClassIdentifier))
            })
            
            it("Get registered identifier custom kind", closure: {
                _ = service.registerViewModelClass(ViewModelExample.self, kind: "Hello_world")
                let result = service.identifierForViewModelClass(ViewModelExample.self, kind: "Hello_world")
                let expectedResult = classIdentifier + "<=>" + "Hello_world"
                expect(result).to(equal(expectedResult))
            })
        }
    }
}
