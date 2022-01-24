//
//  NibOwnerLoadable.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2021/10/29.
//  Copyright © 2021 mitake. All rights reserved.
//

import Foundation

protocol NibOwnerLoadable { }

extension NibOwnerLoadable where Self : UIView {
    /**
     使用此方法加載的Xib IBOutlet的reference需用file's owner拉
     
     - 使用file's owner拉reference的xib可以直接在另一個xib裡面使用
     */
    func loadContentFromXibWithOwner() {
        let nibName = String(describing: type(of: self))
        
        guard let content = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        self.addSubview(content)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([content.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     content.topAnchor.constraint(equalTo: topAnchor),
                                     content.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     content.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
