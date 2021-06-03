// 
//  RipplesView.swift
//
//  Created by Den Jo on 2021/06/01.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct RipplesView: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var radius: CGFloat = 10
    @State private var isAnimated = false
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            ForEach(0..<2) { i in
                ripple
                    .animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false).delay(TimeInterval(i) * 0.28))
            }
        }
        .onAppear {
            radius = 400
            isAnimated = true
        }
    }
    
    // MARK: Private
    private var ripple: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: radius, height: radius)
            .overlay(grayOverlay)
            .overlay(whiteOverlay)
            .opacity(isAnimated ? 0 : 1)
    }
    
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
        let view = RipplesView()
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
