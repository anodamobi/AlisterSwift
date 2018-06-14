//
//  CollectionController.swift
//  AlisterSwift
//
//  Created by Oksana Kovalchuk on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation
import UIKit

open class CollectionController: ListController {

    private var collectionView: UICollectionView

    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init(ListCollectionView.init(collectionView: collectionView))
    }
}

extension CollectionController: UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return activeStorage().sections().count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let section = activeStorage().section(at: section) {
            return section.numberOfObjects
        } else {
            return 0
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = activeStorage().object(at: indexPath) else {
            assert(false, "no cell")
            return UICollectionViewCell()
        }
        
        guard let cell = itemsHandler.cellFor(model, at: indexPath) as? UICollectionViewCell else {
            assert(false, "no cell")
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let model = activeStorage().supplementaryModel(kind: kind, section: indexPath.section) else {
            assert(false, "no model")
            return UICollectionReusableView()
        }
        
        guard let view = itemsHandler.supplementary(model, at: indexPath, kind: kind) as? UICollectionReusableView else {
            assert(false, "no model")
            return UICollectionReusableView()
        }
        
        return view
    }
}


extension CollectionController: UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return size(layout: collectionViewLayout, section: section, isHeader: true)
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return size(layout: collectionViewLayout, section: section, isHeader: false)
    }
    
    private func size(layout: UICollectionViewLayout, section: Int, isHeader: Bool) -> CGSize {
        let kind =  isHeader ? activeStorage().headerKind() : activeStorage().footerKind()
        
        if let model = activeStorage().supplementaryModel(kind: kind, section: section) {
            
            if let size = model.itemSize {
                return size
            } else if let layout = layout as? UICollectionViewFlowLayout {
                return isHeader ? layout.headerReferenceSize : layout.footerReferenceSize
            }
        }
        return CGSize.zero
    }
}

extension CollectionController: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let viewModel = activeStorage().object(at: indexPath) {
            selection?(viewModel, indexPath)
        } else {
            activeStorage().object(at: indexPath)?.selection?()
        }
    }
}
