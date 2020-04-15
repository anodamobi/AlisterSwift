//
//  ItemsHandler.swift
//  AlisterSwift
//
//  Created by Oksana Kovalchuk on 6/4/18.
//  Copyright © 2018 ANODA. All rights reserved.
//

import Foundation

public protocol ListControllerReusableInterface {
    func register<T: ViewModelInterface>(footer: AnyClass, for: T.Type)
    func register<T: ViewModelInterface>(header: AnyClass, for: T.Type)
    func register<T: ViewModelInterface>(cell: AnyClass, for: T.Type)
    func register<T: ViewModelInterface>(supplementary: AnyClass, for: T.Type, kind: String)
}

class ItemsHandler {
    
    weak var listView: ListViewInterface?
    let mapper = ListControllerMappingService()
    
    init(listView: ListViewInterface) {
        self.listView = listView
    }
    
    func cellFor(_ model: ViewModelInterface, at: IndexPath) -> ReusableViewInterface? {
        guard let listView = listView else { assert(false, "shit"); return nil }
        
        guard let identifier = mapper.identifierForViewModelClass(type(of: model)) else {
            assert(false, "Please register your cell before retriving")
            return nil
        }
        
        let cell = listView.cell(identifier: identifier, at: at)
        cell?.update(model)
        return cell
    }
    
    func supplementary(_ model: ViewModelInterface, at: IndexPath?, kind: String) -> ReusableViewInterface? {
        guard let listView = listView else { assert(false, "shit"); return nil }
        
        guard let identifier = mapper.identifierForViewModelClass(type(of: model), kind: kind) else {
            assert(false, "Please register your supplementary before retriving")
            return nil
        }
        
        let view = listView.supplementaryView(identifier: identifier, kind: kind, at: at)
        view?.update(model)
        return view
    }
}

extension ItemsHandler: ListControllerReusableInterface {
    
    func register<T: ViewModelInterface>(footer: AnyClass, for viewModel: T.Type) {
        guard let listView = listView else { assert(false, "shit"); return }
        register(supplementary: footer, for: viewModel, kind: listView.defaultFooterKind)
    }
    
    func register<T: ViewModelInterface>(header: AnyClass, for viewModel: T.Type) {
        guard let listView = listView else { assert(false, "shit"); return }
        register(supplementary: header, for: viewModel, kind: listView.defaultHeaderKind)
    }
    
    func register<T: ViewModelInterface>(cell: AnyClass, for viewModel: T.Type) {
        guard let listView = listView else { assert(false, "shit"); return }
        let ident = mapper.registerViewModelClass(viewModel)
        listView.registerCellClass(cell, forReuseIdentifier: ident)
    }
    
    func register<T: ViewModelInterface>(supplementary: AnyClass, for viewModel: T.Type, kind: String) {
        guard let listView = listView else { assert(false, "shit"); return }
        let ident = mapper.registerViewModelClass(viewModel, kind: kind)
        listView.registerSupplementaryClass(supplementary, reuseIdentifier: ident, kind: kind)
    }
}
