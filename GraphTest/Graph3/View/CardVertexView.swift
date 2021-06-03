// 
//  CardVertexView.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CardVertexView: View {
    
    // MARK: - Value
    // MARK: Public
    @EnvironmentObject var graphData: Graph3Data
    
    // MARK: Private
    @Binding private var data: Vertex
    @State private var isScaled = false
    
    private let action: (() -> Void)?
    private let style = VertexButtonStyle()
    
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
        .modifier(VertexModifier(data: data, angle: graphData.angle, currentAngle: $graphData.currentAngle))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isScaled = true
            }
        }
    }
}

#if DEBUG
struct CardVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = CardVertexView(data: .constant(CardVertex.placeholder))
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
