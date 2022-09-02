//
//  DynamicSize.swift
//  
//
//  Created by 金融研發一部-李鳳謀 on 2022/7/15.
//

import Foundation
import UIKit

extension CGFloat {
    public func scaled() -> CGFloat {
        let width = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        let baseWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 768: 320
        let ratio = width / baseWidth
        return self * ratio
    }
}

extension Int {
    public func scaled() -> CGFloat {
        let width = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        let baseWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 768: 320
        let ratio = width / baseWidth
        return CGFloat(self) * ratio
    }
}

extension Double {
    public func scaled() -> CGFloat {
        let width = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        let baseWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 768: 320
        let ratio = width / baseWidth
        return CGFloat(self) * ratio
    }
}

extension Float {
    public func scaled() -> CGFloat {
        let width = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        let baseWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 768: 320
        let ratio = width / baseWidth
        return CGFloat(self) * ratio
    }
}

extension UIFont {
    static public func bundleDynamicFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size.scaled())
    }
}
