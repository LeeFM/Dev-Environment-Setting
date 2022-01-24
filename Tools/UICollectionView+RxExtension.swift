//
//  UICollectionView+RxExtension.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2021/9/16.
//  Copyright © 2021 mitake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    
    public func cellSelected<C: UICollectionViewCell, T>(_ cellType: C.Type, _ modelType: T.Type) -> ControlEvent<(C, IndexPath, T)> {
        let source: Observable<(C, IndexPath, T)> = itemSelected.flatMap { [weak view = self.base as UICollectionView] indexPath -> Observable<(C, IndexPath, T)> in
            
            guard let view = view,
                  let cell = view.cellForItem(at: indexPath) as? C else {
                return Observable.empty()
            }
            
            return Observable.just((cell, indexPath, try view.rx.model(at: indexPath)))
        }
        
        return ControlEvent(events: source)
    }
}





