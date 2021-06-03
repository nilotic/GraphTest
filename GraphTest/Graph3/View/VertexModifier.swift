// 
//  VertexModifier.swift
//
//  Created by Den Jo on 2021/05/21.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexModifier: AnimatableModifier {
    
    // MARK: - Value
    // MARK: Public
    var animatableData: CGFloat {
        get { angle }
        set { angle = newValue }
    }
    
    // MARK: Private
    private var angle: CGFloat
    @Binding private var currentAngle: CGFloat
    
    private var data: Vertex
    
    
    // MARK: - Initializer
    init(data: Vertex, angle: CGFloat, currentAngle: Binding<CGFloat>) {
        self.data  = data
        self.angle = angle
        
        _currentAngle = currentAngle
    }
    
    
    // MARK: - Function
    // MARK: Public
    func body(content: Content) -> some View {
        DispatchQueue.main.async { currentAngle = angle }
        
        return ZStack {
//            if data.isHighlighted {
//                RippleView()
//                    .offset(x: data.point.x, y: data.point.y)
//                    .rotationEffect(.radians(Double(-angle)))
//            }
            
            content
                .rotationEffect(.radians(Double(angle)))
                .offset(x: data.point.x, y: data.point.y)
                .rotationEffect(.radians(Double(-angle)))
        }
    }
}

