// 
//  UserVertexView.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct UserVertexView: View {
    
    // MARK: - Value
    // MARK: Private
    @Binding private var data: Vertex
    @State private var isScaled = false

    private let action: ((_ isPressed: Bool) -> Void)?
    
    private var radius: CGFloat {
        switch data.priority {
        case 0:     return 120
        case 1:     return 110
        case 2:     return 100
        case 3:     return 90
        case 4:     return 80
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
        default:    return .zero
        }
    }
    
    
    // MARK: - Initializer
    init(data: Binding<Vertex>, action: ((_ isPressed: Bool) -> Void)? = nil) {
        _data = data
        self.action = action
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
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
        .scaleEffect(isScaled ? 1 : 0.001)
        .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
        .modifier(VertexButtonModifier(data: data, action: action))
        .zIndex(1)
        .onAppear {
            isScaled = true
        }
    }
}

#if DEBUG
struct UserVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = UserVertexView(data: .constant(UserVertex.placeholder))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
