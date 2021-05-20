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
    @State private var isDetailViewShown  = false
    @State private var orientation        = UIDevice.current.orientation

    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                guideLine
                graph
                cardsView
            }
            .id(orientation.rawValue)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { value in
                // Stop animations
                update(isAnimated: false)
                
                // Update views
                orientation = (value.object as? UIDevice)?.orientation ?? .landscapeLeft
                
                // Start animations
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    data.request(size: proxy.size)
                    update(isAnimated: true)
                }
            }
            .onAppear {
                data.request(size: proxy.size)
                update(isAnimated: true)
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
                ForEach(1..<20) { i in
                    Path {
                        $0.addArc(center: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2), radius: CGFloat(i) * 40,
                                  startAngle: .radians(0), endAngle: .radians(2 * .pi), clockwise: true)
                    }
                    .stroke(Color.blue, lineWidth: 1)
                }
                        
                
                // Degree
                ForEach(1..<24) {
                    Path {
                        $0.move(to: CGPoint(x: proxy.size.width / 2, y: 0))
                        $0.addLine(to: CGPoint(x: proxy.size.width / 2, y: max(proxy.size.width, proxy.size.height) * 2))
                    }
                    .stroke(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
                    .rotationEffect(.degrees(15 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(0.5)
        }
    }
    
    private var graph: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Vertex
                ForEach(data.vertexes, id: \.id) { vertex in
                    switch vertex {
                    case let data as UserVertex:
                        UserVertexView(data: data) {
                            
                        }
                        
                    case let data as BankVertex:
                        BankVertexView(data: data, isAnimating: $isRotationAnimated) {
                            
                        }
                        
                    case let data as CardVertex:
                        CardVertexView(data: data, isAnimating: $isRotationAnimated) {
                            withAnimation(.spring()) {
                                isDetailViewShown = true
                            }
                        }
                        
                    case let data as InsuranceVertex:
                        InsuranceVertexView(data: data, isAnimating: $isRotationAnimated) {
                            
                        }

                    case let data as MobileVertex:
                        MobileVertexView(data: data, isAnimating: $isRotationAnimated) {
                            
                        }

                    case let data as CoworkerVertex:
                        CoworkerVertexView(data: data, isAnimating: $isRotationAnimated) {
                            
                        }
                        
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
                    .trim(from: 0, to: isLineAnimated ? 1 : 0)
                    .stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 4)
                    .animation(isLineAnimated ? Animation.easeInOut(duration: 0.38).delay(0.1 + 0.1 * TimeInterval(i)) : nil)
                }
                .zIndex(-1)
                .rotationEffect(.degrees(isRotationAnimated ? 360 : 0))
                .animation(isRotationAnimated ? Animation.linear(duration: 120).repeatForever(autoreverses: false) : nil)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    private var cardsView: some View {
        GeometryReader { proxy in
            if isDetailViewShown {
                VStack {
                    Spacer()
                    
                    HikeView(hike: ModelData().hikes[0])
                        .frame(alignment: .bottom)
                }
                .transition(.moveAndFade)
                .frame(height: proxy.size.height)
            }
        }
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func update(isAnimated: Bool) {
        switch isAnimated {
        case false:
            isScaleAnimated    = false
            isLineAnimated     = false
            isRotationAnimated = false
            
        case true:
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
