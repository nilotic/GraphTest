//
//  GraphView.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SwiftUI
import SpriteKit

struct GraphView: View {
    
    // MARK: - Value
    // MARK: Private
    private let graphScene = GraphScene()
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
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
    
    // MARK: Private
    private var editButton: some View {
        Button(action: {
            isConnecting = !isConnecting
            graphScene.isConnecting = isConnecting
                
        }) {
            switch isConnecting {
            case true:
                Image(systemName: "link")
                    .resizable()
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .padding(25)
                    .background(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                    .cornerRadius(66)
                
            case false:
                Image(systemName: "cursorarrow")
                    .scaleEffect(2.2)
                    .rotationEffect(Angle(degrees: -15))
                    .offset(x: 3, y: -2)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .padding(25)
                    .background(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                    .cornerRadius(66)
            }
        }
        .buttonStyle(style1)
    }
    
    // MARK: - Function
    // MARK: Private
    private func setScene(size: CGSize) {
        
    }
    
}

#if DEBUG
struct GraphView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = GraphView()
        
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
