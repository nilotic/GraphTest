// 
//  DepositVertexView.swift
//
//  Created by Den Jo on 2021/06/01.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct DepositVertexView: View {
    
    // MARK: - Value
    // MARK: Private
    private let data: DepositVertex
    private let action: (() -> Void)?
    private let style = VertexButtonStyle()
    
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
    
    
    // MARK: - Initializer
    init(data: DepositVertex, action: (() -> Void)? = nil) {
        self.data   = data
        self.action = action
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Button(action: { action?() }) {
            ZStack {
                Circle()
                    .stroke(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), lineWidth: 2)
                    .background(Circle().foregroundColor(Color.black))
                    .frame(width: 80, height: 80)
                    .padding()
                
                Text(data.name)
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .buttonStyle(style)
        .scaleEffect(isScaled ? 1 : 0.001)
        .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
        .modifier(VertexModifier(angle: 0, currentAngle: .constant(0), point: data.point))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isScaled = true
            }
        }
        .onDrag {
            NSItemProvider(object: data.id as NSString)
        }
    }
}

#if DEBUG
struct DepositVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = DepositVertexView(data: .placeholder)
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
