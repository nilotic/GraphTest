// 
//  AccountVertexView.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct AccountVertexView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: AccountVertex
    
    // MARK: Private
    private var radius: CGFloat {
        switch data.slot.priority {
        case 0:     return 64
        case 1:     return 48
        case 2:     return 40
        default:    return 40
        }
    }
    
    private var imageSize: CGSize {
        switch data.slot.priority {
        case 0:     return CGSize(width: 40, height: 40)
        case 1:     return CGSize(width: 30, height: 30)
        case 2:     return CGSize(width: 22, height: 22)
        default:    return .zero
        }
    }
    
    private var font: Font {
        switch data.slot.priority {
        case 0:     return .system(size: 13, weight: .bold)
        case 1:     return .system(size: 11, weight: .semibold)
        case 2:     return .system(size: 9,  weight: .semibold)
        default:    return .system(size: 9,  weight: .semibold)
        }
    }
    
    private var color: Color {
        switch data.slot.priority {
        case 0:     return Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        case 1:     return Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        case 2:     return Color(#colorLiteral(red: 1, green: 0.8724767566, blue: 0.3582777977, alpha: 1))
        default:    return Color(#colorLiteral(red: 1, green: 0.8724767566, blue: 0.3582777977, alpha: 1))
        }
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 1)
                .background(Circle().foregroundColor(Color.black))
                .frame(width: radius, height: radius)
                
            VStack(spacing: 0) {
                Image(data.imageName)
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
                    
                Text("\(Int(radius))")
                    .font(font)
                    .foregroundColor(color)
            }
            .clipped()
        }
        .zIndex(1)
    }
}

#if DEBUG
struct AccountVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = VStack(spacing: 20) {
            AccountVertexView(data: AccountVertex(id: "0", name: "Oliver", imageName: "memoji1", slot: VertexSlot(slot: 0, offset: 0)))
            AccountVertexView(data: AccountVertex(id: "1", name: "Jake", imageName: "memoji2", slot: VertexSlot(slot: 1, offset: 0)))
            AccountVertexView(data: AccountVertex(id: "2", name: "Noah", imageName: "memoji3", slot: VertexSlot(slot: 2, offset: 0)))
        }
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
