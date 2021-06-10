// 
//  MobileVertexView.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct MobileVertexView: View {
    
    // MARK: - Value
    // MARK: Private
    @Binding private var data: Vertex
    private let action: (() -> Void)?
    
    private var radius: CGFloat {
        switch data.priority {
        case 0:     return 120
        case 1:     return 110
        case 2:     return 100
        case 3:     return 90
        case 4:     return 80
        case 5:     return 70
        case 6:     return 60
        case 7:     return 50
        case 8:     return 40
        case 9:     return 30
        default:    return 0
        }
    }
    
    private var imageSize: CGSize {
        switch data.priority {
        case 0:     return CGSize(width: 98, height: 98)
        case 1:     return CGSize(width: 88, height: 88)
        case 2:     return CGSize(width: 78, height: 78)
        case 3:     return CGSize(width: 68, height: 68)
        case 4:     return CGSize(width: 58, height: 58)
        case 5:     return CGSize(width: 48, height: 48)
        case 6:     return CGSize(width: 41, height: 41)
        case 7:     return CGSize(width: 34, height: 34)
        case 8:     return CGSize(width: 27, height: 27)
        case 9:     return CGSize(width: 20, height: 20)
        default:    return .zero
        }
    }
    
    
    // MARK: - Initializer
    init(data: Binding<Vertex>, action: (() -> Void)? = nil) {
        _data = data
        self.action = action
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Button(action: { action?() }) {
            ZStack {
                Circle()
                    .stroke(Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)), lineWidth: 2)
                    .background(Circle().foregroundColor(Color.black))
                    .frame(width: radius, height: radius)
                    
                Group {
                    if let imageName = data.imageName {
                        Image(imageName)
                            .resizable()
                            .frame(width: imageSize.width, height: imageSize.height)
                            .padding(.bottom, 20 - (CGFloat(data.priority) * 2))
                    }
                    
                    Text(data.name)
                        .font(.system(size: 12 - (CGFloat(data.priority)), weight: .bold))
                        .padding(.top, 70 - (CGFloat(data.priority) * 5))
                }
                .clipped()
            }
            .scaleEffect(data.isScaled ? 1 : 0.001)
            .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
        }
        .buttonStyle(VertexButtonStyle())
        .modifier(VertexModifier(data: data, angle: $data.angle, endAngle: data.endAngle))
    }
}

#if DEBUG
struct MobileVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = MobileVertexView(data: .constant(MobileVertex.placeholder))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
