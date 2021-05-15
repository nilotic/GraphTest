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
    @StateObject private var data = Graph3Data()

    @State private var isScaleAnimated    = false
    @State private var isLineAnimated     = false
    @State private var isRotationAnimated = false
    @State private var scale: CGFloat     = 1
    @State private var opacity: Double    = 1
    @State private var offset: CGSize     = .zero
    @State private var isCardsViewShown   = false
    
    
        
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                guideLine
                graph
                cardsView
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                data.request(size: proxy.size)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isScaleAnimated = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    isLineAnimated = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isRotationAnimated = true
                }
            }
        }
    }
    
    // MARK: Private
    private var guideLine: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Bound
                Color(.clear)
                    .border(Color.gray, width: 1)
                    .frame(width: min(proxy.size.width, proxy.size.height), height: min(proxy.size.width, proxy.size.height))
                
                
                // Orbit
                ForEach(1..<11) { i in
                    Path { path in
                        path.addArc(center: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2), radius: CGFloat(i) * min(proxy.size.width, proxy.size.height) / 10,
                                    startAngle: .radians(0), endAngle: .radians(2 * .pi), clockwise: true)
                    }
                    .stroke(Color.blue, lineWidth: 1)
                }
                        
                
                // Degree
                ForEach(1..<24) {
                    Path { path in
                        path.move(to: CGPoint(x: proxy.size.width / 2, y: 0))
                        path.addLine(to: CGPoint(x: proxy.size.width / 2, y: proxy.size.height))
                    }
                    .stroke(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
                    .rotationEffect(.degrees(15 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(isCardsViewShown ? 0 : 0.5)
        }
    }
    
    private var graph: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Vertex
                ForEach(data.vertexes, id: \.id) { vertex in
                    switch vertex {
                    case let data as UserVertex:
                        UserVertexView(data: data)
                        
                    case let data as BankVertex:
                        BankVertexView(data: data, isAnimating: $isRotationAnimated)
                        
                    case let data as CardVertex:
                        CardVertexView(data: data, isAnimating: $isRotationAnimated)
                            
                            .gesture(DragGesture(minimumDistance: 0).onEnded({ value in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isCardsViewShown = true
                                    scale   = 3
                                    opacity = 0
                                    offset = CGSize(width: (60 - value.location.x) * scale, height: (60 - value.location.y) * scale)
                                }
                            }))
                            
                        
                    case let data as InsuranceVertex:
                        InsuranceVertexView(data: data, isAnimating: $isRotationAnimated)

                    case let data as MobileVertex:
                        MobileVertexView(data: data, isAnimating: $isRotationAnimated)

                    case let data as CoworkerVertex:
                        CoworkerVertexView(data: data, isAnimating: $isRotationAnimated)
                        
                    default:
                        Text("")
                    }
                }
                
                
                // Edge
                ForEach(Array(data.edges.enumerated()), id: \.element) { (i, edge) in
                    Path { path in
                        path.move(to: edge.source.point)
                        path.addLine(to: edge.target.point)
                    }
                    .offset(CGSize(width: proxy.size.width / 2, height: proxy.size.height / 2))
                    .trim(from: 0, to: isLineAnimated ? 1 : 0)
                    .stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 4)
                    .animation(isLineAnimated ? Animation.easeInOut(duration: 0.38).delay(0.1 + 0.1 * TimeInterval(i)) : nil)
                }
                .zIndex(-1)
                .rotationEffect(.degrees(isRotationAnimated ? 360 : 0))
                .animation(isRotationAnimated ? Animation.linear(duration: 60).repeatForever(autoreverses: false) : nil)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(offset)
        }
    }
    
    
    private var cardsView: some View {
        GeometryReader { proxy in
            if isCardsViewShown {
                Graph2View()
                    .frame(width: isCardsViewShown ? proxy.size.width : 0, height: isCardsViewShown ? proxy.size.height : 0)
                    // .matchedGeometryEffect(id: isCardsViewShown ? "cards" : "", in: namespace, properties: .size)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            isCardsViewShown = false
                        }
                    }
                
            }
        }
    }
}

#if DEBUG
struct Graph3View_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = Graph3View()
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
            
        }
    }
}
#endif
