//
//  TitledViewModel.swift
//  Alister
//
//  Created by Alexander Kravchenko on 6/12/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit

class DefaultHeaderVM: ViewModelInterface {
    
    var title: String
    var selection: Selection?
    
    var itemSize: CGSize? {
        return CGSize(width: 0, height: 44)
    }
    
    init(title: String = "") {
        self.title = title
    }
}

