// 
//  ThumbnailButtonStyle.swift
//
//  Created by Den Jo on 2021/06/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct ThumbnailButtonStyle: ButtonStyle {
    
    // MARK: - Value
    // MARK: Private
    @State private var isDisabled = false
    @State private var pressedDate: Date? = nil
    @State private var isAppeared = false
    
    private let index: Int

    private var animation: Animation {
        isAppeared ? .easeInOut(duration: 0.17) : .spring(dampingFraction: 0.5)
                                                    .speed(1.2)
                                                    .delay(0.04 * TimeInterval(index))
    }
    
    
    // MARK: - Initializer
    init(index: Int) {
        self.index = index
    }
    
    
    // MARK: - Function
    // MARK: Public
    func makeBody(configuration: Configuration) -> some View {
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
                .onChange(of: configuration.isPressed, perform: handle)
                .disabled(isDisabled)
                .scaleEffect(configuration.isPressed ? 0.89 : 1, anchor: .center)
                .animation(animation)
        }
    }

    // MARK: Private
    private func handle(isPressed: Bool) {
        switch isPressed {
        case true:
            let date = Date()
            pressedDate = date
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                guard date == pressedDate else { return }
                isDisabled = true
                
                DispatchQueue.main.async { isDisabled = false }
            }
            
        case false:
            pressedDate = nil
            isDisabled = false
        }
    }
}
