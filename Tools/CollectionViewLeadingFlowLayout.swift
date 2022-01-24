//
//  CollectionViewLeadingFlowLayout.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2021/9/14.
//  Copyright © 2021 mitake. All rights reserved.
//

import UIKit

class CollectionViewLeadingFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
