//
//  MainVC.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 10.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit
import AlisterSwift

enum DetailControllers {
    case carList
    case headerFooter
    case dragNdrop
    case carsColleciton
}

class MainVC: UIViewController {
    private var controller: TableController
    private let tableView = UITableView()
    
    init() {
        controller = TableController(tableView: tableView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        controller.configureCells { config in
            config.register(cell: TitleTableCell.self, for: TitleCellVM.self)
        }

        let models = [TitleCellVM(title: "Search", selection: {
                        self.presentController(.carList)
                      }),
                      TitleCellVM(title: "Header/Footer", selection: {
                        self.presentController(.headerFooter)
                      }),
                      TitleCellVM(title: "Drag and Drop", selection: {
                        self.presentController(.dragNdrop)
                      }),
                      TitleCellVM(title: "Collection example", selection: {
                        self.presentController(.carsColleciton)
                      })]
        
        controller.storage.update { update in
            update.add(models)
        }
    }

    func presentController(_ type: DetailControllers) {
        let vc: UIViewController
        switch type {
        case .carList:
            vc = CarsListVC()
        case .headerFooter:
            vc = CarsListVC(type: .headerFooter)
        case .dragNdrop:
            vc = CarsListVC(type: .dragAndDrop)
        default:
            vc = CarsCollectionVC()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureUI() {
        title = "Alister"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
