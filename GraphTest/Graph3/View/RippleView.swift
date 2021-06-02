// 
//  RippleView.swift
//
//  Created by Den Jo on 2021/06/01.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct RippleView: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var radius: CGFloat = 10
    @State private var isAnimated = false
    

    // MARK: - View
    // MARK: Public
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: radius, height: radius)
            .overlay(grayOverlay)
            .overlay(whiteOverlay)
            .opacity(isAnimated ? 0 : 1)
            .onAppear {
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                    radius = 300
                    isAnimated = true
                }
            }
    }
    
    // MARK: Private
    private var grayOverlay: some View {
        Circle()
            .stroke(Color.gray, lineWidth: 5)
            .blur(radius: 3)
            .offset(x: 2, y: 2)
    }
    
    private var whiteOverlay: some View {
        Circle()
            .stroke(Color.white, lineWidth: 5)
            .blur(radius: 3)
            .offset(x: -2, y: -2)
    }
}


#if DEBUG
struct RippleView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = RippleView()
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
