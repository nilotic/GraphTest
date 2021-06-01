// 
//  BankVertexView.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct BankVertexView: View {
    
    // MARK: - Value
    // MARK: Private
    private let data: BankVertex
    private let action: (() -> Void)?
    private let style = VertexButtonStyle()
    
    @State private var isScaled = false
    @State private var isRippleAnimated = false
    @State private var rippleRadius: CGFloat = 0
    
    @Binding private var angle: CGFloat
    @Binding private var currentAngle: CGFloat
    
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
    
    
    // MARK: - Initializer
    init(data: BankVertex, angle: Binding<CGFloat>, currentAngle: Binding<CGFloat>, action: (() -> Void)? = nil) {
        self.data    = data
        self.action  = action
        
        _angle        = angle
        _currentAngle = currentAngle
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Button(action: { action?() }) {
            ZStack {
                if rippleRadius != 0 {
                    Circle()
                        .fill(Color.white.opacity(rippleRadius == 0 ? 0 : 0.5))
                        .frame(width: 70 + offset + rippleRadius, height: 70 + offset + rippleRadius)
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.5))
//                        .onAppear {
//                            withAnimation {
//                                rippleRadius = 200
//                            }
//                        }
                }
                
                Circle()
                    .stroke(Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)), lineWidth: 2)
                    .background(Circle().foregroundColor(Color.black))
                    .frame(width: 70 + offset, height: 70 + offset)
                    
                Group {
                    if let imageName = data.imageName {
                        Image(imageName)
                            .resizable()
                            .frame(width: 48 + offset, height: 48 + offset)
                            .padding(.bottom, 20 - (CGFloat(data.priority) * 2))
                    }
                    Text(data.name)
                        .font(.system(size: 12 - (CGFloat(data.priority)), weight: .bold))
                        .padding(.top, 70 - (CGFloat(data.priority) * 5))
                }
                .clipped()
            }
        }
        .buttonStyle(style)
        .scaleEffect(isScaled ? 1 : 0.001)
        .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
        .modifier(VertexModifier(angle: angle, currentAngle: $currentAngle, point: data.point))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isScaled = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    rippleRadius = 30
                }
            }
        }
        
    }
}

#if DEBUG
struct BankVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = BankVertexView(data: .placeholder, angle: .constant(0), currentAngle: .constant(0))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
