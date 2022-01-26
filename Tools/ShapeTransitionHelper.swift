//
//  ShapeTransitionHelper.swift
//  CustomerService
//
//  Created by 金融研發一部-李鳳謀 on 2022/1/25.
//

import UIKit

class ShapeTransitionHelper {
    
    typealias State = (begin: CGFloat, end: CGFloat)
    typealias AttributeSetting = [UIView: [Attribute]]
    typealias ConstraintSetting = [NSLayoutConstraint: State]
    
    enum Attribute {
        case alpha(State)
        case cornerRadius(State)
    }
    
    enum Action {
        case toBegin
        case move(CGFloat)
        case toEnd
    }
    
    var attributeTransitions: AttributeSetting
    var constraintTransitions: ConstraintSetting
    
    var lowerbound: CGFloat
    var upperbound: CGFloat
    
    init(attributeTransitions: AttributeSetting = [:],
         constraintTransitions: ConstraintSetting = [:],
         lowerbound: CGFloat,
         upperbound: CGFloat) {
        
        self.attributeTransitions = attributeTransitions
        self.constraintTransitions = constraintTransitions
        self.lowerbound = lowerbound
        self.upperbound = upperbound
    }
    
    func toBeginState() {
        handleAttributeSetting(with: .toBegin)
        handleConstraintSetting(with: .toBegin)
    }
    
    func toEndState() {
        handleAttributeSetting(with: .toEnd)
        handleConstraintSetting(with: .toEnd)
    }
    
    func processTransition(progress: CGFloat) {
        handleAttributeSetting(with: .move(progress))
        handleConstraintSetting(with: .move(progress))
    }
    
    private func handleAttributeSetting(with action: Action) {
        for transition in attributeTransitions {
            let view = transition.key
            let setting = transition.value
            
            for attribute in setting {
                switch attribute {
                case .alpha(let state):
                    if let value = getValue(state: state, action: action) {
                        view.alpha = value
                    }
                    break
                case .cornerRadius(let state):
                    if let value = getValue(state: state, action: action) {
                        view.layer.cornerRadius = value
                    }
                    break
                }
            }
        }
    }
    
    private func handleConstraintSetting(with action: Action) {
        for transition in constraintTransitions {
            let constraint = transition.key
            
            if let value = getValue(state: transition.value, action: action) {
                constraint.constant = value
            }
        }
    }
    
    private func getValue(state: State, action: Action) -> CGFloat? {
        switch action {
        case .toBegin:
            return state.begin
        case .toEnd:
            return state.end
        case .move(let progress):
            
            if lowerbound...upperbound ~= progress {
                let ratio = (progress - lowerbound) / (upperbound - lowerbound)
                
                if state.begin > state.end {
                    // 遞減
                    //
                    // begin    x           end
                    // lower  progress      upper
                    //  |-------|------------|
                    //
                    // (begin - progress)     (progress - lower)
                    // ------------------- = --------------------
                    //   (begin - end)         (upper - lower)
                    
                    return state.begin - (state.begin - state.end) * ratio
                } else {
                    // 遞增
                    return (state.end - state.begin) * ratio + state.begin
                }
            } else {
                return nil
            }
        }
    }
}
