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
    private let action: ((_ status: TouchStatus) -> Void)?
    
    private var radius: CGFloat {
        switch data?.priority ?? 0 {
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
                    .frame(width: radius, height: radius)
                
                Text(data.name)
                    .font(.system(size: 12, weight: .bold))
            }
            .buttonStyle(VertexButtonStyle())
            .scaleEffect(data.isScaled ? (data.scale) : 0.001)
            .animation(.spring(response: 0.38, dampingFraction: 0.5, blendDuration: 0))
            .modifier(DraggableButtonModifier(data: data, action: action))
            .zIndex(2)
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
