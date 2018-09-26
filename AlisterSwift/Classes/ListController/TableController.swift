//
//  TableController.swift
//  AlisterSwift
//
//  Created by Oksana Kovalchuk on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit

open class TableController: ListController {
    
    private var tableView: UITableView
    
    public var shouldDisplayHeaderOnEmptySection = true
    public var shouldDisplayFooterOnEmptySection = true
    public var isEditingAllowed = false
    public var isMovingAllowed = false {
        didSet {
            tableView.setEditing(isMovingAllowed, animated: true)
        }
    }
    public var editingCompletion: ((UITableViewCellEditingStyle, IndexPath) -> Void)?
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init(ListTableView(tableView: tableView))
    }
    
    func updateDefaultUpdateAnimationModel(_ model: TableUpdateConfigurationModel) {
        if let tableListView = listView as? ListTableView {
            tableListView.configModel = model
        }
    }
    
    private func viewForSupplementary(index: Int, kind: String) -> UITableViewHeaderFooterView? {
        if let model = supplementaryModel(index: index, kind: kind) {
            return itemsHandler.supplementary(model, at: nil, kind: kind) as? UITableViewHeaderFooterView
        }
        return nil
    }

    
    private func heightForSupplementary(index: Int, kind: String) -> CGFloat {
        
        //apple bug HACK: for plain tables, for bottom section separator visibility
        let isHeader = kind == activeStorage().headerKind()
        let shouldMaskSeparator = tableView.style == .plain && !isHeader
        
        let minHeight = shouldMaskSeparator == true ? 0.1 : CGFloat.leastNormalMagnitude
        
        var height = minHeight
        if let model = supplementaryModel(index: index, kind: kind) {
            
            height = isHeader == true ? tableView.sectionHeaderHeight : tableView.sectionFooterHeight
            
            if let size = model.itemSize {
                return size.height
            } else if  height > 0 {
                return height
            } else {
                return UITableViewAutomaticDimension
            }
        }
        return height
    }
    
    private func supplementaryModel(index: Int, kind: String) -> ViewModelInterface? {
        let isHeader = kind == activeStorage().headerKind()
        let shouldDisplay = isHeader == true ? shouldDisplayHeaderOnEmptySection : shouldDisplayFooterOnEmptySection
        
        var model: ViewModelInterface?
        
        if let section = activeStorage().section(at: index), section.numberOfObjects > 0 || shouldDisplay {
            if isHeader == true {
                model = activeStorage().headerModel(section: index)
            } else {
                model = activeStorage().footerModel(section: index)
            }
        }
        return model
    }
}


//MARK: - Delegate

extension TableController: UITableViewDelegate {

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForSupplementary(index: section, kind: activeStorage().headerKind())
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForSupplementary(index: section, kind: activeStorage().footerKind())
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForSupplementary(index: section, kind: activeStorage().footerKind())
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForSupplementary(index: section, kind: activeStorage().headerKind())
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return storage.object(at: indexPath)?.itemSize?.height ?? tableView.rowHeight
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditingAllowed
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        editingCompletion?(editingStyle, indexPath)
    }
    
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isMovingAllowed
    }
    
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return isMovingAllowed ? .none : .delete
    }
    
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return !isMovingAllowed
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

//MARK: - Data Source
extension TableController: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return activeStorage().sections().count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = activeStorage().section(at: section) {
            return model.numberOfObjects
        } else {
            return 0
        }
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = activeStorage().object(at: indexPath) else {
            assert(false, "you should register cell")
            return UITableViewCell()
        }
        
        guard let cell = itemsHandler.cellFor(model, at: indexPath) as? UITableViewCell else {
            assert(false, "you should register cell")
            return UITableViewCell()
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let closure = activeStorage().object(at: indexPath)?.selection {
            closure()
        } else if let viewModel = activeStorage().object(at: indexPath) {
            selection?(viewModel, indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        activeStorage().update { (config) in
            config.moveWithoutUpdate(from: sourceIndexPath, to: destinationIndexPath)
        }
    }
}
