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
    @Binding private var data: DepositVertex?
    @State private var isScaled = false
        
    private let action: ((_ status: TouchStatus) -> Void)?
    private let style = VertexButtonStyle()
    
    private var offset: CGFloat {
        switch data?.priority ?? 0 {
        case 0:     return 50
        case 1:     return 40
        case 2:     return 30
        case 3:     return 20
        case 4:     return 10
        default:    return 0
        }
    }
    
    
    // MARK: - Initializer
    init(data: Binding<DepositVertex?>?, action: ((_ status: TouchStatus) -> Void)? = nil) {
        _data = data ?? .constant(nil)
        self.action = action
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        if let data = data {
            ZStack {
                Circle()
                    .stroke(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), lineWidth: 2)
                    .background(Circle().foregroundColor(Color.black))
                    .frame(width: 80 + offset, height: 80 + offset)
                
                Text(data.name)
                    .font(.system(size: 12, weight: .bold))
            }
            .buttonStyle(style)
            .scaleEffect(isScaled ? (data.scale) : 0.001)
            .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
            .modifier(DraggableButtonModifier(data: data, action: action))
            .zIndex(2)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isScaled = true
                }
            }
        }
    }
}

#if DEBUG
struct DepositVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = DepositVertexView(data: .constant(DepositVertex.placeholder))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
