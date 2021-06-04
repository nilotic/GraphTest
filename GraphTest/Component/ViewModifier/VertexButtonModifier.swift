// 
//  VertexButtonModifier.swift
//
//  Created by Den Jo on 2021/05/24.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexButtonModifier: ViewModifier {
    
    // MARK: - Value
    // MARK: Public
    var action: ((_ isPressed: Bool) -> Void)?
    
    // MARK: Private
    @State private var isPressed = false
    private var data: Vertex
    
    
    // MARK: - Initializer
    init(data: Vertex, action: ((_ isPressed: Bool) -> Void)?) {
        self.data   = data
        self.action = action
    }
      
        
    // MARK: - Function
    // MARK: Public
    func body(content: Content) -> some View {
        return ZStack {
            if data.isHighlighted {
                RipplesView()
            }
            
            content
                .offset(x: data.point.x, y: data.point.y)
                .scaleEffect(isPressed ? 0.89 : 1, anchor: .center)
                .animation(.easeInOut(duration: 0.17))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            guard !isPressed else { return }
                            isPressed = true
                            
                            action?(isPressed)
                        }
                        .onEnded { _ in
                            guard isPressed else { return }
                            isPressed = false
                            
                            action?(isPressed)
                        }
                )
        }
    }
}
 
