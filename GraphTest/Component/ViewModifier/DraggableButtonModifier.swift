// 
//  DraggableButtonModifier.swift
//
//  Created by Den Jo on 2021/06/01.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct DraggableButtonModifier: ViewModifier {
    
    // MARK: - Value
    // MARK: Public
    let data: Vertex
    var action: ((_ status: TouchStatus) -> Void)?
    
    
    // MARK: Private
    @State private var isPressed = false
    @State private var offset: CGPoint = .zero
    @State private var frame: CGRect = .zero
    @State private var startPoint: CGPoint? = nil
    @State private var delta: CGSize? = nil
    @State private var scale: CGFloat = 1
    @State private var isReset = false
    
    
    // MARK: - Function
    // MARK: Public
    func body(content: Content) -> some View {
        content
            .frame {
                frame = $0
            }
            .scaleEffect(scale)
            .scaleEffect(isPressed ? 0.89 : 1, anchor: .center)
            .animation(isReset ? .spring(response: 0.38, dampingFraction: 0.7, blendDuration: 0) : .easeInOut(duration: 0.17))
            .offset(x: data.point.x + offset.x, y: data.point.y + offset.y)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isPressed = true
                        
                        guard let delta = delta else {
                            delta = CGSize(width: value.location.x - data.point.x, height: value.location.y - data.point.y)
                            return
                        }
                        
                        let x = value.location.x - delta.width
                        let y = value.location.y - delta.height
                        
                        offset = CGPoint(x: x - data.point.x, y: y - data.point.y)
                        action?(.moved(CGRect(x: x, y: y, width: frame.width, height: frame.height)))
                    }
                    .onEnded { _ in
                        action?(.ended)
                        delta = nil
                        isReset = true
                        isPressed = false
                        
                        switch data.isHighlighted {
                        case true:  scale = 0.001
                        case false: offset = .zero
                        }
                        
                        // Reset the flag after finishing the animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isReset = false
                        }
                    }
            )
    }
}
 
