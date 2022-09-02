//
//  Array+Ext.swift
//  
//
//  Created by 金融研發一部-李鳳謀 on 2022/7/15.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
