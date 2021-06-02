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
    let point: CGPoint
    var action: ((_ status: TouchStatus) -> Void)?
    
    
    // MARK: Private
    @State private var isPressed = false
    @State private var offset: CGPoint = .zero
    @State private var frame: CGRect = .zero
    @State private var startPoint: CGPoint? = nil
    @State private var delta: CGSize? = nil
    
    
    // MARK: - Function
    // MARK: Public
    func body(content: Content) -> some View {
        content
            .frame {
                frame = $0
            }
            .scaleEffect(isPressed ? 0.89 : 1, anchor: .center)
            .animation(.easeInOut(duration: 0.17))
            .offset(x: point.x + offset.x, y: point.y + offset.y)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isPressed = true
                        
                        guard let delta = delta else {
                            delta = CGSize(width: value.location.x - point.x, height: value.location.y - point.y)
                            return
                        }
                        
                        let x = value.location.x - delta.width
                        let y = value.location.y - delta.height
                        
                        offset = CGPoint(x: x - point.x, y: y - point.y)
                        action?(.moved(CGRect(x: x, y: y, width: frame.width, height: frame.height)))
                    }
                    .onEnded { _ in
                        action?(.ended)
                        isPressed = false
                        delta = nil
                    }
            )
    }
}
 
