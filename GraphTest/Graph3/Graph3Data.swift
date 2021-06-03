// 
//  Graph3Data.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

final class Graph3Data: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var vertexes = [Vertex]()
    @Published var edges    = [GraphEdge]()
    
    @Published var orientation = UIDevice.current.orientation
    
    @Published var isScaleAnimated   = false
    @Published var isLineAnimated    = false
    @Published var isDetailViewShown = false
    
    @Published var angle: CGFloat         = 0
    @Published var previousAngle: CGFloat = 0
    @Published var currentAngle: CGFloat  = 0
    @Published var isCurved               = false
    @Published var curveRatio: CGFloat    = 0
    @Published var isCurveAnimating       = false
    
    @Published var depositVertex: DepositVertex? = nil
    
    var animationWorkItem: DispatchWorkItem? = nil
    let unit: CGFloat = 40
    
    let curveSize  = CGSize(width: 190, height: 50)
    let curveUnit  = CGFloat.pi / 6
    let curveCount = 12
    
    let duration: Double = 120
    
    var controlPointAngle: CGFloat {
        atan2(curveSize.width / 2, curveSize.height)
    }
    
    
    // MARK: Private
    private var frames = [CGRect]()
    
    
    // MARK: - Function
    // MARK: Public
    func request(size: CGSize) {
        guard let url = Bundle.main.url(forResource: "graph", withExtension: "json") else { return }
        
        do {
            let data = try JSONDecoder().decode(GraphResponse.self, from: try Data(contentsOf: url))
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            var vertexes = [Vertex]()
            var frames = [CGRect]()
            
            let vertexSize = { (priority: UInt) -> CGSize in
                var offset: CGFloat {
                    switch priority {
                    case 0:     return 50
                    case 1:     return 40
                    case 2:     return 30
                    case 3:     return 20
                    case 4:     return 10
                    default:    return 0
                    }
                }
                
                let radius = CGFloat(70) + offset
                return CGSize(width: radius, height: radius)
            }
            
            
            // User
            let userVertex = UserVertex(data: data.user, point: center)
            vertexes.append(userVertex)
            frames.append(CGRect(origin: .zero, size: vertexSize(data.user.priority)))
            
            
            // Vertex, Edge
            var edges = [GraphEdge]()
            for graph in data.user.graphs {
                guard let vertex = graph.nodes.sorted(by: { $0.priority < $1.priority }).first else { continue }

                switch vertex {
                case let data as BankNode:
                    let point  = CGPoint(x: 0, y: unit * 6)
                    let vertex = BankVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as CardNode:
                    let point  = CGPoint(x: unit * 3, y: 0)
                    let vertex = CardVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as InsuranceNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 8
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = InsuranceVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as MobileNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 5
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = MobileVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as CoworkerNode:
                    let radius = unit * 6
                    let radian = CGFloat.pi / 6 * 10
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = CoworkerVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                default:
                    continue
                }
            }
            
            DispatchQueue.main.async {
                self.vertexes = vertexes
                self.edges    = edges
                self.frames   = frames
            }
    
        } catch {
            log(.error, error.localizedDescription)
        }
    }
    
    func update(isAnimated: Bool) {
        switch isAnimated {
        case false:
            isScaleAnimated = false
            isLineAnimated  = false
            depositVertex   = nil
            
            angle = 0
            
            for i in 0..<vertexes.count {
                vertexes[i].isHighlighted = false
            }
            
        case true:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isScaleAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                self.isLineAnimated = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(Animation.linear(duration: self.duration).repeatForever(autoreverses: false)) {
                    self.angle = -2 * .pi
                }
            }
        }
    }
    
    func handle(isPressed: Bool) {
        isCurved = isPressed
        
        // Animation Lock
        isCurveAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isCurveAnimating = false
        }
        
        // Cancel the rotation animation
        animationWorkItem?.cancel()
            
        // Curve animation
        switch isCurved {
        case false:
            withAnimation(.easeInOut(duration: 0.25)) {
                curveRatio = 0
                angle      = previousAngle
            }

            // Resume the rotation animation
            let workItem = DispatchWorkItem {
                withAnimation(Animation.linear(duration: self.duration).repeatForever(autoreverses: false)) {
                    self.angle = self.currentAngle - 2 * .pi
                }
            }
            
            animationWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
            
        case true:
            previousAngle = currentAngle
                        
            withAnimation(.easeInOut(duration: 0.25)) {
                curveRatio = 1
                angle      = currentAngle - .pi / 9
            }
        }
    }
    
    func handle(status: TouchStatus) {
        switch status {
        case .moved(let frame):
            guard frames.count == vertexes.count else { return }
            
            // Vertexes
            var isHighlighted = false
            for i in 1..<vertexes.count {
                vertexes[i].isHighlighted = frames[i].intersects(frame)
                isHighlighted = isHighlighted || vertexes[i].isHighlighted
            }
            
            // Deposit Vertex
            var scale: CGFloat {
                let distance = (sqrt(pow(frame.origin.x, 2) + pow(frame.origin.y, 2))) - 80
                let ratio = 1 - (distance / 400)
                
                return min(max(ratio, 0.77), 1)
            }
            
            depositVertex?.scale         = scale
            depositVertex?.isHighlighted = isHighlighted
            
        case .ended:
            depositVertex?.scale = 1
            
            var higlightedIndex: Int? {
                for i in 1..<vertexes.count {
                    guard vertexes[i].isHighlighted else { continue }
                    return i
                }
                
                return nil
            }
            
            guard let index = higlightedIndex else { return }
            vertexes[0].isHighlighted = false       // User
            vertexes[index].isHighlighted = false   // Target
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // Reset the deposit vertex
                self.depositVertex = nil
                
                // Rotation animation
                withAnimation(Animation.linear(duration: self.duration).repeatForever(autoreverses: false)) {
                    self.angle = self.currentAngle - 2 * .pi
                }
            }
        }
    }
    
    func addDeposit() {
        // Stop Rotation
        withAnimation(.easeOut(duration: 0.38)) {
            angle = currentAngle - ((.pi / 180) / (360 / CGFloat(duration)))
        }
        
        // Update frames
        for (i, frame) in frames.enumerated() {
            frames[i].origin = frame.origin.applying(CGAffineTransform(rotationAngle: -angle))
        }
        
        // Add a deposit vertex
        depositVertex = DepositVertex(nodeID: "deposit1", name: "₩50,000", priority: 4, point: CGPoint(x: 45, y: 45), isHighlighted: false, scale: 1)
        
        // Add ripples
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.vertexes[0].isHighlighted = true
        }
    }
}
