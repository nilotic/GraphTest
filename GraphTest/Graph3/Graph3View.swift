// 
//  Graph3View.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Graph3View: View {
    
    // MARK: - Value
    // MARK: Private
    private let data = Graph3Data()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                guideLine
        
                
    
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .onAppear {
            data.request()
        }
    }
    
    // MARK: Private
    private var guideLine: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center)  {
                // Bound
                Color(.clear)
                    .border(Color.gray, width: 1)
                    .frame(width: min(proxy.size.width, proxy.size.height), height: min(proxy.size.width, proxy.size.height))
                
                
                // Circle
                ForEach(1..<11) {
                    Circle()
                        .stroke(Color.blue)
                        .frame(width: CGFloat($0) * min(proxy.size.width, proxy.size.height) / 10, height: CGFloat($0) * min(proxy.size.width, proxy.size.height) / 10)
                }
                        
                        
                // Degree
                ForEach(1..<24) {
                    Path { path in
                        path.move(to: CGPoint(x: proxy.size.width / 2, y: 0))
                        path.addLine(to: CGPoint(x: proxy.size.width / 2, y: proxy.size.height))
                        
                    }
                    .stroke(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
                    .rotationEffect(Angle(degrees: 15 * Double($0)))
                }
                    
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

#if DEBUG
struct Graph3View_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = Graph3View()
        
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
