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

    @State private var isScaleAnimated      = false
    @State private var isLineAnimated       = false
    @State private var isRotationAnimated   = false
    @State private var isDetailViewShown    = false
    
    @State private var angle: CGFloat        = 0
    @State private var currentAngle: CGFloat = 0
    @State private var isCurved              = false
    @State private var curveRatio: CGFloat   = 0
    @State private var orientation           = UIDevice.current.orientation
    
    private let curveSize  = CGSize(width: 190, height: 50)
    private let curveUnit  = CGFloat.pi / 6
    private let curveCount = 12
    
    private var controlPointAngle: CGFloat {
        atan2(curveSize.width / 2, curveSize.height)
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        
        
        GeometryReader { proxy in
            ZStack {
//                DemoView()
                guideLine
                // curveGuideLine
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
                    .rotationEffect(.radians(.pi / 12 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(0.5)
        }
    }
    
    private var curveGuideLine: some View {
        GeometryReader { proxy in
            ZStack {
                // Curve Box
                ForEach(0..<curveCount) {
                    ZStack {
                        Rectangle()
                            .frame(width: curveSize.width, height: curveSize.height)
                            .border(Color.red)
                            .offset(x: curveSize.width / 2, y: -curveSize.height / 2)
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .offset(x: curveSize.width / 2, y: -curveSize.height)
                    }
                    .rotationEffect(.radians(.pi / 6 * Double($0)))
                }
                
                // Control Point
                ForEach(0..<curveCount) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 5, height: 5)
                        .offset(x: ((curveSize.width / 2 + 12) * cos(controlPointAngle + curveUnit * CGFloat($0))), y: (curveSize.width / 2 + 12) * sin(controlPointAngle + curveUnit * CGFloat($0)))
                }
                
                // Curve
                ForEach(0..<curveCount) {
                    EdgeShape(source: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2),
                              target: CGPoint(x: proxy.size.width / 2 + curveSize.width * cos(curveUnit * CGFloat($0)), y: proxy.size.height / 2 + curveSize.width * sin(curveUnit * CGFloat($0))),
                              size: curveSize,
                              ratio: curveRatio)
                        .stroke(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), lineWidth: 3)
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
//                            withAnimation(.easeInOut(duration: 0.38)) {
//                                curveRatio = (curveRatio == nil || curveRatio == 0) ? 1 : 0
//                                angle = curveRatio == 1 ? .pi / 9 : 0
//                            }
                            
                            isCurved.toggle()
                            log(.info, isCurved)
                            
                            let startAngle = currentAngle.truncatingRemainder(dividingBy: -2 * .pi)
                            let angleDelta: CGFloat = isCurved ? 0 : -2 * .pi
                            
                            withAnimation(isCurved ? .linear(duration: 0) : Animation.linear(duration: 120).repeatForever(autoreverses: false)) {
                                curveRatio = isCurved ? 0 : 1
                                angle = startAngle + angleDelta
                            }
                        }
                        
                    case let data as BankVertex:
                        BankVertexView(data: data, angle: $angle, currentAngle: $currentAngle, isAnimating: $isRotationAnimated) {
                            
                        }
                        
                        
                    case let data as CardVertex:
                        CardVertexView(data: data, angle: $angle, currentAngle: $currentAngle, isAnimating: $isRotationAnimated) {
                            withAnimation(.spring()) {
                                isDetailViewShown = true
                            }
                        }
                    
                    case let data as InsuranceVertex:
                        InsuranceVertexView(data: data, angle: $angle, currentAngle: $currentAngle, isAnimating: $isRotationAnimated) {
                            
                        }
                    
                    case let data as MobileVertex:
                        MobileVertexView(data: data, angle: $angle, currentAngle: $currentAngle, isAnimating: $isRotationAnimated) {
                            
                        }

                    case let data as CoworkerVertex:
                        CoworkerVertexView(data: data, angle: $angle, currentAngle: $currentAngle, isAnimating: $isRotationAnimated) {
                            
                        }
                    
                    default:
                        Text("")
                    }
                }
                /*
                // Edge
                ForEach(Array(data.edges.enumerated()), id: \.element) { (i, edge) in
                    EdgeShape(source: edge.source.point,target: edge.target.point, size: curveSize, ratio: (curveRatio))
                        .trim(from: 0, to: isLineAnimated ? 1 : 0)
                        .stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 3)
                        .animation(isLineAnimated ? Animation.easeInOut(duration: isCurved ? 0.2 : 0.38).delay(curveRatio == nil ? (0.1 + 0.1 * TimeInterval(i)) : 0) : nil)
                }
                .zIndex(-1)
                .rotationEffect(.radians(isRotationAnimated ? 2 * .pi : 0))
                .animation(isRotationAnimated ? Animation.linear(duration: 120).repeatForever(autoreverses: false) : nil)*/
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
            
            angle = 0
            
        case true:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isScaleAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                isLineAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(Animation.linear(duration: 12).repeatForever(autoreverses: false)) {
                    angle = -2 * .pi
                    isRotationAnimated = true
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
