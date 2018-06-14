//
//  CarsListVC.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 06.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit

enum CarsListVCType {
    case search
    case headerFooter
    case dragAndDrop
}

class CarsListVC: UIViewController {
    
    private var controller: CarsListController
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let type: CarsListVCType
    
    init(type: CarsListVCType = .search) {
        self.type = type
        controller = CarsListController(tableView: tableView, canMoveRows: type == .dragAndDrop)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupStorage()
    }

    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        // Enabling search feature
        guard type == .search else { return }
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = true
        navigationItem.titleView = searchBar
        controller.attachSearchBar(searchBar)
    }
    
    private func setupStorage() {
        
        // Allow move cells
        if type == .dragAndDrop {
            tableView.setEditing(true, animated: true)
        }

        // Registering cells/headers/footers
        controller.configureCells { config in
            config.register(cell: CarCell.self, for: CarCellViewModel.self)
            config.register(footer: CarsTableHeaderFooter.self, for: CarsTableHeaderFooterVM.self)
            config.register(header: CarsTableHeaderFooter.self, for: CarsTableHeaderFooterVM.self)
        }
        
        // Behavior if row was selected
        var models = TestDataGenerator.carModels()
        for model in models {
            model.selection = {
                self.showAlert(title: model.carMake)
            }
        }
        let modelsSection1 = Array(models[0..<5])
        let modelsSection2 = Array(models[5..<10])

        controller.storage.update { [unowned self] update in
            
            // Adding rows to the table
            update.add(modelsSection1)
            update.add(modelsSection2, to: 1)
            
            // Adding header and footer to some sections
            if self.type == .headerFooter {
                update.update(headerModel: CarsTableHeaderFooterVM(title: "Section 0 Header"), section: 0)
                update.update(headerModel: CarsTableHeaderFooterVM(title: "Section 1 Header"), section: 1)
                update.update(footerModel: CarsTableHeaderFooterVM(title: "Section 1 Footer"), section: 1)
            }
        }
        
        setupSearchController()
    }
    
    private func showAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
