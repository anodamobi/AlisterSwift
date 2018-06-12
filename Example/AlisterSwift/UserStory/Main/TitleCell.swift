//
//  TitleCell.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 10.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import SnapKit
import AlisterSwift

class TitleCellVM: ViewModelInterface {

    var title: String
    var selection: Selection?
    
    var itemSize: CGSize? {
        return CGSize(width: 0, height: 44)
    }
    
    init(title: String = "Title", selection: @escaping Selection) {
        self.title = title
        self.selection = selection
    }
}

class TitleTableCell: UITableViewCell, ReusableViewInterface {
    
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
        guard let vm = model as? TitleCellVM else { return }
        title.text = vm.title
    }
}
