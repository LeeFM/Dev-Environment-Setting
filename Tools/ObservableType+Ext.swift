//
//  ObservableType+Ext.swift
//  Test
//
//  Created by 金融研發一部-李鳳謀 on 2022/2/28.
//

import Foundation

extension ObservableType {
    
    // MARK: - 增
    func withAppendedResultFrom<Source: ObservableConvertibleType>(_ second: Source) -> Observable<Source.Element> where Source.Element == Array<Self.Element> {
        
        let result = self.withLatestFrom(second, resultSelector: { itemToAdd, lastArray in
            return lastArray + [itemToAdd]
        })
        
        return result
    }
    
    func withAppendedResultFrom<Source: ObservableConvertibleType, T>(_ second: Source) -> Observable<Source.Element> where Self.Element == Array<T>, Source.Element == Self.Element {
        
        let result = self.withLatestFrom(second, resultSelector: { itemsToAdd, lastArray in
            
            return lastArray + itemsToAdd
        })
        
        return result
    }
    
    func withInsertedResultAtFirstFrom<Source: ObservableConvertibleType, T>(_ second: Source) -> Observable<Source.Element> where Self.Element == Array<T>, Source.Element == Self.Element {
        
        let result = self.withLatestFrom(second, resultSelector: { itemsToAdd, lastArray in
            
            return itemsToAdd + lastArray
        })
        
        return result
    }
    
    func withInsertedResultFrom<Source: ObservableConvertibleType>(_ second: Source, at index: Int) -> Observable<Source.Element> where Source.Element == Array<Self.Element> {
        
        let result = self.withLatestFrom(second, resultSelector: { (itemToAdd, lastArray) -> Source.Element in
            
            var modifiedArray = lastArray
            modifiedArray.insert(itemToAdd, at: index)
            
            return modifiedArray
        })
        
        return result
    }
    
    // MARK: - 刪
    func withDeletedResultFrom<Source: ObservableConvertibleType>(_ second: Source) -> Observable<Source.Element> where Source.Element == Array<Self.Element>, Self.Element: Equatable {
        
        let result = self.withLatestFrom(second, resultSelector: { (itemToDelete, lastArray) -> Source.Element in
            
            if let index = lastArray.firstIndex(of: itemToDelete) {
                
                var modifiedArray = lastArray
                modifiedArray.remove(at: index)
                
                return modifiedArray
            }
            
            return lastArray
        })
        
        return result
    }
    
    func withDeletedResultAtLastFrom<Source: ObservableConvertibleType, T>(_ second: Source) -> Observable<Source.Element> where Source.Element == Array<T>, Self.Element == Void {
        
        let result = self.withLatestFrom(second, resultSelector: { (_, lastArray) -> Source.Element in
            
            var modifiedArray = lastArray
            modifiedArray.removeLast()
            
            return modifiedArray
        })
        
        return result
    }
    
    func withDeletedResultAtFirstFrom<Source: ObservableConvertibleType, T>(_ second: Source) -> Observable<Source.Element> where Source.Element == Array<T>, Self.Element == Void {
        
        let result = self.withLatestFrom(second, resultSelector: { (_, lastArray) -> Source.Element in
            
            var modifiedArray = lastArray
            modifiedArray.removeFirst()
            
            return modifiedArray
        })
        
        return result
    }
    
    // MARK: - 改
    func withReplaceedResultFrom<Source: ObservableConvertibleType>(_ second: Source, at index: Int) -> Observable<Source.Element> where Source.Element == Array<Self.Element> {
        
        let result = self.withLatestFrom(second, resultSelector: { (itemToReplace, lastArray) -> Source.Element in
            
            var modifiedArray = lastArray
            modifiedArray[index] = itemToReplace
            
            return modifiedArray
        })
        
        return result
    }
}
