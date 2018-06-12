//
//  CarsTableHeaderFooter.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 10.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit
import AlisterSwift

class CarsTableHeaderFooterVM: ViewModelInterface {
    
    var headerTitle: String
    
    init(title: String = "Custom header view") {
        headerTitle = title
    }
    
    var itemSize: CGSize? {
        return CGSize(width: 0, height: 36)
    }
}

class CarsTableHeaderFooter: UITableViewHeaderFooterView, ReusableViewInterface {
    
    private let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundView = UIView(frame: CGRect.zero)
        backgroundView?.backgroundColor = .lightGray
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func update(_ model: ViewModelInterface) {
        guard let vm = model as? CarsTableHeaderFooterVM else { return }
        titleLabel.text = vm.headerTitle
    }
}
