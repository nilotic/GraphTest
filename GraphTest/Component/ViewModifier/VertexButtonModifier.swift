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
    
    
    // MARK: - Function
    // MARK: Public
    func body(content: Content) -> some View {
        content
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
 
