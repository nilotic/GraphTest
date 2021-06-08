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
        get { endAngle }
        set { endAngle = newValue }
    }
    
    // MARK: Private
    private var endAngle: CGFloat
    @Binding private var angle: CGFloat
    
    private var data: Vertex
    @State private var radius: CGFloat = 0
    
    private var highlightRadius: CGFloat {
        radius + 15
    }
    
    
    // MARK: - Initializer
    init(data: Vertex, angle: Binding<CGFloat>, endAngle: CGFloat) {
        self.data     = data
        self.endAngle = endAngle
        
        _angle = angle
    }
    
    
    // MARK: - Function
    // MARK: Public
    func body(content: Content) -> some View {
        DispatchQueue.main.async { angle = endAngle }
        
        return ZStack {
            Circle()
                .fill(Color(#colorLiteral(red: 0.6292319784, green: 0.5738882467, blue: 1, alpha: 0.3483730089)))
                .frame(width: highlightRadius, height: highlightRadius)
                .scaleEffect(data.isHighlighted ? 1 : 0.001)
                .opacity(data.isHighlighted ? 1 : 0)
                .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
                .offset(x: data.point.x, y: data.point.y)
                .rotationEffect(.radians(Double(-endAngle)))

            content
                .rotationEffect(.radians(Double(endAngle)))
                .offset(x: data.point.x, y: data.point.y)
                .rotationEffect(.radians(Double(-endAngle)))
                .frame {
                    radius = $0.size.width
                }
        }
    }
}

