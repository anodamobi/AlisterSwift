//
//  CarsCollectionVC.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 10.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit
import AlisterSwift

class CarsCollectionVC: UIViewController {
    
    private var controller: CarsCollectionController
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    
    init() {
        controller = CarsCollectionController(collectionView: collectionView)
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
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStorage() {
        controller.configureCells { (config) in
            config.register(cell: CarCollectionCell.self, for: CarCellViewModel.self)
        }

        let models = TestDataGenerator.carModels()
        controller.storage.update { (update) in
            update.add(models)
        }
    }
}
