//___FILEHEADER___

import Foundation
import AlisterSwift
import SnapKit

class ___FILEBASENAMEASIDENTIFIER___VM: ViewModelInterface {

    var itemSize: CGSize?
    var searchEvaluation: SearchEval?
    var selection: Selection?
}

class ___FILEBASENAMEASIDENTIFIER___: UICollectionViewCell, ReusableViewInterface {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func update(_ model: ViewModelInterface) {
        
        guard let viewModel = model as? ___FILEBASENAMEASIDENTIFIER___VM else { return }
        
    }
    
    
    //MARK: - Private
    private func setupLayout() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
