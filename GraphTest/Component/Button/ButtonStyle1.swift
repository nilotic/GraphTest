// 
//  ButtonStyle1.swift
//
//  Created by Den Jo on 2021/04/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct ButtonStyle1: ButtonStyle {
    
    // MARK: - Value
    // MARK: Private
    @ObservedObject private var data = ButtonStyle1Data()
    
    
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
                guard !data.isAppeared else { return }
                data.isAppeared = 0 <= frame.origin.x
            }
            
            // Content View
            configuration.label
                .opacity(configuration.isPressed ? 0.5 : 1)
                .scaleEffect(configuration.isPressed ? 0.92 : 1)
                .animation(data.isAppeared ? .easeInOut(duration: 0.18) : nil)
        }
    }
}
