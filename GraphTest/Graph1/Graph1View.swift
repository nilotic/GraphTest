//
//  Graph1View.swift
//
//  Created by Den Jo on 2021/05/04.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI
import SpriteKit

struct Graph1View: View {
    
    // MARK: - Value
    // MARK: Private
    private let graphScene = Graph1Scene()
    private let style1 = ButtonStyle1()
    
    @State private var isConnecting = false
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            SpriteView(scene: graphScene)
                .frame {
                    graphScene.size = $0.size
                    graphScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                }
        
            editButton
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
        }
    }
    
    // MARK: Private
    private var editButton: some View {
        Button(action: {
            isConnecting = !isConnecting
            graphScene.data.isConnecting = isConnecting
                
        }) {
            ZStack {
                // Background
                Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1))
                
                // Image
                switch isConnecting {
                case true:
                    Image(systemName: "link")
                        .scaleEffect(1.5)
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                        .foregroundColor(.white)
                    
                case false:
                    Image(systemName: "hand.tap.fill")
                        .rotationEffect(.degrees(-15))
                        .scaleEffect(1.5)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 66, height: 66)
            .cornerRadius(33)
        }
        .buttonStyle(style1)
    }
}

#if DEBUG
struct GraphView1_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = Graph1View()
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.light)
            
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
