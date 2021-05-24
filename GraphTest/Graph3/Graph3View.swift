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

    
    // MARK: - View
    // MARK: Public
    var body: some View {        
        GeometryReader { proxy in
            ZStack {
                guideLine
                // curveGuideLine
                graph
                cardsView
            }
            .id(data.orientation.rawValue)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { value in
                // Stop animations
                update(isAnimated: false)
                
                // Update views
                data.orientation = (value.object as? UIDevice)?.orientation ?? .landscapeLeft
                
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
                ForEach(0..<data.curveCount) {
                    ZStack {
                        Rectangle()
                            .frame(width: data.curveSize.width, height: data.curveSize.height)
                            .border(Color.red)
                            .offset(x: data.curveSize.width / 2, y: -data.curveSize.height / 2)
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .offset(x: data.curveSize.width / 2, y: -data.curveSize.height)
                    }
                    .rotationEffect(.radians(.pi / 6 * Double($0)))
                }
                
                // Control Point
                ForEach(0..<data.curveCount) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 5, height: 5)
                        .offset(x: ((data.curveSize.width / 2 + 12) * cos(data.controlPointAngle + data.curveUnit * CGFloat($0))), y: (data.curveSize.width / 2 + 12) * sin(data.controlPointAngle + data.curveUnit * CGFloat($0)))
                }
                
                // Curve
                ForEach(0..<data.curveCount) {
                    EdgeShape(source: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2),
                              target: CGPoint(x: proxy.size.width / 2 + data.curveSize.width * cos(data.curveUnit * CGFloat($0)), y: proxy.size.height / 2 + data.curveSize.width * sin(data.curveUnit * CGFloat($0))),
                              size: data.curveSize,
                              ratio: data.curveRatio)
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
                // Edge
                ForEach(Array(data.edges.enumerated()), id: \.element) { (i, edge) in
                    EdgeShape(edge: edge, size: data.curveSize, ratio: data.curveRatio)
                        .trim(from: 0, to: data.isLineAnimated ? 1 : 0)
                        .stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 3)
                        .animation(data.isLineAnimated ? Animation.easeInOut(duration: data.isCurveAnimating ? 0.25 : 0.38).delay(data.isCurveAnimating ? 0 : (0.1 + 0.1 * TimeInterval(i))) : nil)
                }
                .rotationEffect(.radians(Double(-data.angle)))
                .animation(data.isRotationAnimated ? Animation.linear(duration: data.duration).repeatForever(autoreverses: false) : Animation.easeInOut(duration: 0.25))
                
                
                // Vertex
                ForEach(data.vertexes, id: \.id) { vertex in
                    switch vertex {
                    case let data as UserVertex:
                        UserVertexView(data: data) {
                           updateVertexes()
                        }
                        
                    case let data as BankVertex:
                        BankVertexView(data: data, angle: $data.angle, currentAngle: $data.currentAngle) {
                            
                        }
                        
                    case let data as CardVertex:
                        CardVertexView(data: data, angle: $data.angle, currentAngle: $data.currentAngle) {
                            withAnimation(.spring()) {
                                self.data.isDetailViewShown = true
                            }
                        }
                    
                    case let data as InsuranceVertex:
                        InsuranceVertexView(data: data, angle: $data.angle, currentAngle: $data.currentAngle) {
                            
                        }
                    
                    case let data as MobileVertex:
                        MobileVertexView(data: data, angle: $data.angle, currentAngle: $data.currentAngle) {
                            
                        }

                    case let data as CoworkerVertex:
                        CoworkerVertexView(data: data, angle: $data.angle, currentAngle: $data.currentAngle) {
                            
                        }
                    
                    default:
                        Text("")
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    private var cardsView: some View {
        GeometryReader { proxy in
            if data.isDetailViewShown {
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
            data.isScaleAnimated    = false
            data.isLineAnimated     = false
            data.isRotationAnimated = false
            
            data.angle = 0
            
        case true:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                data.isScaleAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                data.isLineAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(Animation.linear(duration: data.duration).repeatForever(autoreverses: false)) {
                    data.angle = -2 * .pi
                    data.isRotationAnimated = true
                }
            }
        }
    }
    
    private func updateVertexes() {
        data.isCurved.toggle()
        
        data.isCurveAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            data.isCurveAnimating = false
        }
        
        switch data.isCurved {
        case false:
            let start = data.currentAngle.truncatingRemainder(dividingBy: -2 * .pi)
            let delta: CGFloat = (start + (.pi / 9)).truncatingRemainder(dividingBy: 2 * .pi)
            
            withAnimation(.easeInOut(duration: 0.25)) {
                data.curveRatio = 0
                data.angle = delta
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(Animation.linear(duration: data.duration).repeatForever(autoreverses: false)) {
                    data.isRotationAnimated = true
                    data.angle = -2 * .pi
                }
            }
            
        case true:
            data.isRotationAnimated = false
            let start = data.currentAngle.truncatingRemainder(dividingBy: -2 * .pi)
            let delta: CGFloat = (start + (.pi / -9)).truncatingRemainder(dividingBy: 2 * .pi)
            
            withAnimation(.easeInOut(duration: 0.25)) {
                data.curveRatio = 1
                data.angle = delta
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
