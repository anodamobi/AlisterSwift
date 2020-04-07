//
//  CarsCollectionController.swift
//  AlisterSwift
//
//  Created by Alexander Kravchenko on 10.06.2018.
//  Copyright © 2018 ANODA. All rights reserved.
//

import UIKit
import AlisterSwift

class CarsCollectionController: CollectionController {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth / 3.3
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
