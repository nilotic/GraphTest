// 
//  VertexButtonStyle.swift
//
//  Created by Den Jo on 2021/05/17.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexButtonStyle: ButtonStyle {
    
    // MARK: - Value
    // MARK: Public
    let anchor: UnitPoint
 
    // MARK: Private
    @State private var isAppeared = false
    
    
    // MARK: - Function
    // MARK: Public
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            // Dummy for tracking the view status
            GeometryReader {
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: $0.frame(in: .global))
            }
            .frame(width: 0, height: 0)
            .onPreferenceChange(FramePreferenceKey.self) { frame in
                guard !isAppeared else { return }
                isAppeared = 0 <= frame.origin.x
            }
            
            // Content View
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.89 : 1, anchor: anchor)
                .animation(isAppeared ? .easeInOut(duration: 0.17) : nil)
        }
    }
}

