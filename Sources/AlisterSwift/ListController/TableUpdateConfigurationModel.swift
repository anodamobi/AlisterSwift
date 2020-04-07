//
//  TableUpdateConfigurationModel.swift
//  Alister
//
//  Created by Maxim Danilov on 5/31/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit

class TableUpdateConfigurationModel {
    
    var insertSectionAnimation: UITableView.RowAnimation = .none
    var deleteSectionAnimation: UITableView.RowAnimation = .none
    var reloadSectionAnimation: UITableView.RowAnimation = .none
    var insertRowAnimation: UITableView.RowAnimation = .none
    var deleteRowAnimation: UITableView.RowAnimation = .none
    var reloadRowAnimation: UITableView.RowAnimation = .none
    
    static func defaultModel() -> TableUpdateConfigurationModel {
        
        let configModel = TableUpdateConfigurationModel()
        
        configModel.insertSectionAnimation = .none
        configModel.deleteSectionAnimation = .automatic
        configModel.reloadSectionAnimation = .automatic
        
        configModel.insertRowAnimation = .automatic
        configModel.deleteRowAnimation = .automatic
        configModel.reloadRowAnimation = .automatic
        
        return configModel
    }
}
