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
    @State private var radius: CGFloat = 0
    
    private var highlightRadius: CGFloat {
        radius + 20
    }
    
    
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
            Circle()
                .fill(Color(#colorLiteral(red: 0.6292319784, green: 0.5738882467, blue: 1, alpha: 0.3483730089)))
                .frame(width: highlightRadius, height: highlightRadius)
                .scaleEffect(data.isHighlighted ? 1 : 0.001)
                .opacity(data.isHighlighted ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.38, blendDuration: 0))
                .offset(x: data.point.x, y: data.point.y)
                .rotationEffect(.radians(Double(-angle)))

            content
                .rotationEffect(.radians(Double(angle)))
                .offset(x: data.point.x, y: data.point.y)
                .rotationEffect(.radians(Double(-angle)))
                .frame {
                    radius = $0.size.width
                }
        }
    }
}

