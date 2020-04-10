//___FILEHEADER___

import Foundation
import AlisterSwift
import SnapKit

class ___FILEBASENAMEASIDENTIFIER___VM: ViewModelInterface {

    var itemSize: CGSize?
    var searchEvaluation: SearchEval?
    var selection: Selection?
}

class ___FILEBASENAMEASIDENTIFIER___: UITableViewCell, ReusableViewInterface {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
