// 
//  MobileVertexView.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct MobileVertexView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: MobileVertex
    @Binding var isAnimating: Bool
    
    // MARK: Private
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
        .rotationEffect(.degrees(isAnimating ? -360 : 0))
        .offset(x: data.point.x, y: data.point.y)
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(isAnimating ? Animation.linear(duration: 30).repeatForever(autoreverses: false) : nil)
    }
}

#if DEBUG
struct MobileVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = MobileVertexView(data: .placeholder, isAnimating: .constant(false))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
