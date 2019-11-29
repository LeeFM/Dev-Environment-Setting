//___FILEHEADER___

import UIKit

class ___FILEBASENAMEASIDENTIFIER___: UIView {
    
    private var shouldSetupConstraints = true
    
    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        // do something
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func updateConstraints() {
        if shouldSetupConstraints {
            setupConstraints()
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    // MARK: Lazy var
    
}

// MARK: Constraints
extension ___FILEBASENAMEASIDENTIFIER___ {
    fileprivate func setupConstraints() {
        
    }
}
