// 
//  CoworkerVertexView.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CoworkerVertexView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: CoworkerVertex
    @Binding var isAnimating: Bool
    
    // MARK: Private
    @State private var isScaled = false
    
    private var offset: CGFloat {
        switch data.priority {
        case 0:     return 50
        case 1:     return 40
        case 2:     return 30
        case 3:     return 20
        case 4:     return 10
        default:    return 0
        }
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)), lineWidth: 2)
                .background(Circle().foregroundColor(Color.black))
                .frame(width: 70 + offset, height: 70 + offset)
                .padding()
            
            Group {
                Image(data.imageName)
                    .resizable()
                    .frame(width: 48 + offset, height: 48 + offset)
                    .padding(.bottom, 20 - (CGFloat(data.priority) * 2))
                
                Text(data.name)
                    .font(.system(size: 12 - (CGFloat(data.priority)), weight: .bold))
                    .padding(.top, 70 - (CGFloat(data.priority) * 5))
            }
            .clipped()
        }
        .scaleEffect(isScaled ? 1 : 0.001)
        .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
        .rotationEffect(.degrees(isAnimating ? -360 : 0))
        .offset(x: data.point.x, y: data.point.y)
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(isAnimating ? Animation.linear(duration: 60).repeatForever(autoreverses: false) : nil)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isScaled = true
            }
        }
    }
}

#if DEBUG
struct CoworkerVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = CoworkerVertexView(data: .placeholder, isAnimating: .constant(false))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
