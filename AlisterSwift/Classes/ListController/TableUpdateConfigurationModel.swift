//
//  TableUpdateConfigurationModel.swift
//  Alister
//
//  Created by Maxim Danilov on 5/31/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit

class TableUpdateConfigurationModel {
    
    var insertSectionAnimation: UITableViewRowAnimation = .none
    var deleteSectionAnimation: UITableViewRowAnimation = .none
    var reloadSectionAnimation: UITableViewRowAnimation = .none
    var insertRowAnimation: UITableViewRowAnimation = .none
    var deleteRowAnimation: UITableViewRowAnimation = .none
    var reloadRowAnimation: UITableViewRowAnimation = .none
    
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
