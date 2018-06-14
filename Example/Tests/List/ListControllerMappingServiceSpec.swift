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

class TT: Hashable, ViewModelInterface {
    var id: String = ""
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func ==(lhs: TT, rhs: TT) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListControllerMappingServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Mapping Service tests") {
            
            let service = ListControllerMappingService()
            let classIdentifier = String(describing: TT.self)
            let fullClassIdentifier = classIdentifier + "<=>" + "kANDefaultCellKind"
            
            it("Register Class", closure: {
                let result = service.registerViewModelClass(TT.self)
                expect(result) == fullClassIdentifier
            })
            
            it("Register Class custom kind", closure: {
                let result = service.registerViewModelClass(TT.self, kind: "Hello_world")
                let expectedResult = classIdentifier + "<=>" + "Hello_world"
                expect(result) == expectedResult
            })
            
            it("Get registered identifier", closure: {
                _ = service.registerViewModelClass(TT.self)
                let result = service.identifierForViewModelClass(TT.self)
                expect(result).to(equal(fullClassIdentifier))
            })
            
            it("Get registered identifier custom kind", closure: {
                _ = service.registerViewModelClass(TT.self, kind: "Hello_world")
                let result = service.identifierForViewModelClass(TT.self, kind: "Hello_world")
                let expectedResult = classIdentifier + "<=>" + "Hello_world"
                expect(result).to(equal(expectedResult))
            })
        }
    }
}

