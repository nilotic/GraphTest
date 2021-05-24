// 
//  VertexModifier.swift
//
//  Created by Den Jo on 2021/05/21.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexModifier: GeometryEffect {
    
    // MARK: - Value
    // MARK: Public
    var animatableData: CGFloat {
        get { angle }
        set { angle = newValue }
    }
    
    // MARK: Private
    private var angle: CGFloat = 0
    private var point: CGPoint = .zero
    
    @Binding private var currentAngle: CGFloat
    
    
    // MARK: - Initializer
    init(angle: CGFloat, currentAngle: Binding<CGFloat>, point: CGPoint) {
        self.angle = angle
        self.point = point
        
        self._currentAngle = currentAngle
    }
    
    
    // MARK: - Function
    // MARK: Public
    func effectValue(size: CGSize) -> ProjectionTransform {
        DispatchQueue.main.async { currentAngle = angle }
        
        return ProjectionTransform(CGAffineTransform(rotationAngle: -angle)
                                    .translatedBy(x: point.x, y: point.y)
                                    .rotated(by: angle))
    }
}

