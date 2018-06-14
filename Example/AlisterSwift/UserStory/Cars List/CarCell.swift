//
//  CarCell.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 06.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit
import AlisterSwift

class CarCellViewModel: ViewModelInterface {
    
    var carMake: String
    var carCylindersQuantity: Int
    var selection: Selection?
    
    var searchEvaluation: SearchEval? {
        let eval: SearchEval = { searchText, scope in
            return self.carMake.lowercased().contains(searchText.lowercased())
        }
        return eval
    }
    
    // Works for both UITableView and UICollectionView
    var itemSize: CGSize? {
        return CGSize(width: 44, height: 44)
    }
    
    init(_ car: Car) {
        self.carMake = car.make
        self.carCylindersQuantity = car.cylindersQuantity
    }
}

class CarCell: UITableViewCell, ReusableViewInterface {
    
    private let title = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func update(_ model: ViewModelInterface) {
        guard let carModel = model as? CarCellViewModel else { return }
        title.text = "\(carModel.carMake) V\(carModel.carCylindersQuantity)"
    }
}
