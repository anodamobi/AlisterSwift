//
//  CarCollectionCell.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 10.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit
import AlisterSwift

class CarCollectionCell: UICollectionViewCell, ReusableViewInterface {
    
    private let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .lightGray
        title.textAlignment = .center
        title.numberOfLines = 0
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func update(_ model: ViewModelInterface) {
        guard let vm = model as? CarCellViewModel else { return }
        title.text = "\(vm.carMake) V\(vm.carCylindersQuantity)"
    }
}
