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
    @ObservedObject private var data = Graph3Data()
    @State private var isAnimating = false
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                guideLine
                graph
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onAppear {
                data.request(size: proxy.size)
                isAnimating = true
            }
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
                    .rotationEffect(Angle(degrees: 15 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    private var graph: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center)  {
                
                // Vertex
                ForEach(data.vertexes) { vertex in
                    switch vertex.data {
                    case let data as User:  UserVertexView(data: data)
                    default:                Text("")
                    }
                }
                
                BankVertexView(data: BankNode(id: "", name: "SC", imageName: "sc", priority: 5))
                    .rotationEffect(.degrees(isAnimating ? -360 : 0))
                    .offset(x: 0, y: min(proxy.size.width, proxy.size.height) / 10 * 6)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 25).repeatForever(autoreverses: false))

                CardVertexView(data: CardNode(id: "", name: "VISA", imageName: "visa", priority: 4))
                    .rotationEffect(.degrees(isAnimating ? -360 : 0))
                    .offset(x: min(proxy.size.width, proxy.size.height) / 10 * 3, y: 0)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 30).repeatForever(autoreverses: false))

                MobileVertexView(data: MobileNode(id: "", name: "at&t", imageName: "at&t", priority: 3))
                    .rotationEffect(.degrees(isAnimating ? -360 : 0))
                    .offset(x: min(proxy.size.width, proxy.size.height) / 10 * 4 * cos(.pi / 6 * 8),
                            y: min(proxy.size.width, proxy.size.height) / 10 * 4 * sin(.pi / 6 * 8))
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 30).repeatForever(autoreverses: false))
                
                InsuranceVertexView(data: InsuranceNode(id: "0", name: "AIG", imageName: "aig", priority: 5))
                    .rotationEffect(.degrees(isAnimating ? -360 : 0))
                    .offset(x: min(proxy.size.width, proxy.size.height) / 10 * 4 * cos(.pi / 6 * 5),
                            y: min(proxy.size.width, proxy.size.height) / 10 * 4 * sin(.pi / 6 * 5))
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 30).repeatForever(autoreverses: false))
                
                CoworkerVertexView(data: CoworkerNode(id: "0", name: "Elizabeth", imageName: "memoji11", priority: 2))
                    .rotationEffect(.degrees(isAnimating ? -360 : 0))
                    .offset(x: min(proxy.size.width, proxy.size.height) / 10 * 6 * cos(.pi / 6 * 10),
                            y: min(proxy.size.width, proxy.size.height) / 10 * 6 * sin(.pi / 6 * 10))
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 20).repeatForever(autoreverses: false))

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
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
            
        }
    }
}
#endif
