//
//  StorageModel.swift
//  ANODA-Alister-iOS8.0
//
//  Created by Oksana Kovalchuk on 5/30/18.
//

import Foundation

/**
 Private class for storing in objects in memory.
 You should not use or call this class directly.
 */

protocol StorageModelInterface {
    /**
     This used only for object difference inside storage.
     */
    var footerKind: String { get }
    
    /**
     This uses only for object difference inside storage.
     */
    var headerKind: String { get }
    
    /**
     Returns array of all sections
     
     @return array with ANStorageSectionModels inside
     */
    var sections: [SectionModel] { get }
    
    /**
     Returns array of items for the specified section index
     @param section section index which objects should be returned
     @return array of items from specified section
     */
    func itemsInSection(_ index: Int) -> [ViewModelInterface]
    
    /**
     Returns specified object by indexPath.
     By index.section - will find section and then by indexPath.row will return object from section items array.
     If item at specified indexPath not exists will return nil.
     
     @param indexPath indexPath for item
     
     @return item at specified indexPath or nil if item is not found in storage
     */
    func itemAt(_ indexPath: IndexPath) -> ViewModelInterface?
    

    /**
     Returns section model by index
     
     @param index index for section
     
     @return ANStorageSectionModel* object from storage
     */
    func sectionAt(_ index: Int) -> SectionModel? // TODO:
    
    
    /**
     Adds new section in the end of sections array
     
     @param section section object to add
     */
    
    func addSection(_ section: SectionModel, at: Int?)
    
    func removeSection(_ index: Int)
    
    func removeAllSections()
}

class StorageModel: StorageModelInterface {

    var sections: [SectionModel] {
        return sectionModels
    }
    
    public var numberOfSections: Int {
        return sectionModels.count
    }
    
    private var sectionModels: [SectionModel]
    
    init(sections: [SectionModel] = []) {
        sectionModels = sections
    }
    
    func sectionAt(_ index: Int) -> SectionModel? {
        if (0..<sectionModels.count).contains(index) {
            return sectionModels[index]
        }
        return nil
    }
    
    func addSection(_ section: SectionModel, at: Int? = nil) {
        if let index = at {
            //TODO: index out of bounds
            sectionModels.insert(section, at: index)
        } else {
            sectionModels.append(section)
        }
    }

    public func itemsInSection(_ index: Int) -> [ViewModelInterface] {
        if sectionModels.count > index {
            return sectionModels[index].objects
        }
        return []
    }
    
    public func itemAt(_ indexPath: IndexPath) -> ViewModelInterface? {
        if sectionModels.count > indexPath.section {
            let section = sectionModels[indexPath.section]
            if section.objects.count > indexPath.row {
                return section.objects[indexPath.row]
            }
        }
        return nil
    }

    func removeSection(_ index: Int) {
        sectionModels.remove(at: index)
    }
    
    func removeAllSections() {
        sectionModels.removeAll()
    }
    
    func isEmpty() -> Bool {
        var count = 0
        for section in sectionModels {
            count += section.objects.count
        }
        return count == 0
    }
    
    var footerKind: String = "ANStorageFooterKind" {
        didSet {
            for section in sectionModels {
                section.replaceSupplementary(oldValue, on: footerKind)
            }
        }
    }
    
    var headerKind: String = "ANStorageHeaderKind" {
        didSet {
            for section in sectionModels {
                section.replaceSupplementary(oldValue, on: headerKind)
            }
        }
    }
    
    func debugDescription() -> String {
        var result = ""
        sectionModels.enumerated().forEach { (index, object) in
            result += "=================Section #\(index))================\n"
            if object.supplementaryObjects.count > 0 {
                 result += "supplementaries { \n"
                
                object.supplementaryObjects.enumerated().forEach({ (offset, element) in
                    result += "    \(element.key) - \(element.value)\n"
                })
                
                result += "}\n"
                result += "Objects = { \n"
                
                object.objects.enumerated().forEach({ (index, item) in
                    result += "    \(index) = { \(item) }\n"
                })
                
                result += "}\n"
            }
        }
        return result
    }
}
