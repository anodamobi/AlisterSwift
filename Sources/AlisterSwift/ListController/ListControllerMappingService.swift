//
//  ANListControllerMappingService.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

protocol ListControllerMappingServiceInterface: class {
    func registerViewModelClass<T: ViewModelInterface>(_ viewModelClass: T.Type, kind: String?) -> String
    func identifierForViewModelClass(_ viewModelClass: ViewModelInterface.Type?, kind: String?) -> String?
}

fileprivate enum EntityType: Equatable, Hashable {
    case cell
    case supplementary(kind: String)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .cell:
            hasher.combine(0)
        case .supplementary(let kind):
            hasher.combine(kind.hashValue + 1)
        }
    }
    
    static func == (lhs: EntityType, rhs: EntityType) -> Bool {
        switch (lhs, rhs) {
        case (.cell, .cell):
            return true
        case let (.supplementary(kindLeft), .supplementary(kindRight)):
            return kindLeft == kindRight
        default:
            return false
        }
    }
}

fileprivate struct IdentifierMapEntity {
    
    private let kANDefaultCellKind = "kANDefaultCellKind"
    
    var identifier: String
    var type: EntityType
    var modelClass: ViewModelInterface.Type
    
    var hashValue: Int {
        return identifier.hashValue ^ String(describing: modelClass).hashValue + type.hashValue
    }
    
    static func == (lhs: IdentifierMapEntity, rhs: IdentifierMapEntity) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.modelClass == rhs.modelClass
            && lhs.type == rhs.type
    }
    
    func fullIdentifier() -> String {
        var kindString = kANDefaultCellKind
        
        switch type {
        case .supplementary(let kind):
            kindString = kind
        default:
            break
        }
        
        return "\(identifier)<=>\(kindString)"
    }
}

class ListControllerMappingService: ListControllerMappingServiceInterface {
    
    private let defaultNullIdentifier = "null-mapping-key"
    private var identifierStorage = [String: IdentifierMapEntity]()
    
    // MARK: Interface methods
    
    func registerViewModelClass<T: ViewModelInterface>(_ viewModelClass: T.Type, kind: String? = nil) -> String {
        let result: IdentifierMapEntity
        
        if let kind = kind {
            result = registerIdentifier(for: viewModelClass, type: .supplementary(kind: kind))
        } else {
            result = registerIdentifier(for: viewModelClass, type: .cell)
        }
        
        return result.fullIdentifier()
    }
    
    func identifierForViewModelClass(_ viewModelClass: ViewModelInterface.Type?, kind: String? = nil) -> String? {

        guard let viewModelClass = viewModelClass else {
            assert(false, "view model class is nil")
            return nil
        }
        
        var type: EntityType = .cell
        
        if let kind = kind {
            type = .supplementary(kind: kind)
        }
        
        var result: String? = nil
        
        identifierStorage.enumerated().forEach { (offset, element) in
            if element.value.type == type {
                if element.value.modelClass == viewModelClass {
                    result = element.value.fullIdentifier()
                }
            }
        }
        return result
    }
    
    // MARK: Private methods
    
    private func registerIdentifier<T: ViewModelInterface>(for viewModelClass: T.Type, type: EntityType) -> IdentifierMapEntity {
        let identifier = String(describing: viewModelClass)
        let entity = IdentifierMapEntity(identifier: identifier, type: type, modelClass: viewModelClass)
        identifierStorage[entity.fullIdentifier()] = entity
        return entity
    }
}
