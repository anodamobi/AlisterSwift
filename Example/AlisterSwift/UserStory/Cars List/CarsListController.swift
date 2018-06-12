//
//  CarsListController.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 6/11/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import AlisterSwift

class CarsListController: TableController {
    
    private let canMoveRows: Bool
    
    init(tableView: UITableView, canMoveRows: Bool = false) {
        self.canMoveRows = canMoveRows
        super.init(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRows
    }
}
