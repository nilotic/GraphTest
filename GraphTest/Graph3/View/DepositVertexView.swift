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
    private let action: ((_ status: TouchStatus) -> Void)?
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
    init(data: DepositVertex, action: ((_ status: TouchStatus) -> Void)? = nil) {
        self.data   = data
        self.action = action
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), lineWidth: 2)
                .background(Circle().foregroundColor(Color.black))
                .frame(width: 80 + offset, height: 80 + offset)
            
            Text(data.name)
                .font(.system(size: 12, weight: .bold))
        }
        .buttonStyle(style)
        .scaleEffect(isScaled ? 1 : 0.001)
        .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
        .modifier(DraggableButtonModifier(point: data.point, action: action))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isScaled = true
            }
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
