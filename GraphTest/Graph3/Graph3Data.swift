// 
//  Graph3Data.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI
import AVFoundation

final class Graph3Data: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var vertexes      = [Vertex]()
    @Published var vertexIndices = [Int]()
    @Published var edges         = [GraphEdge]()
    
    @Published var orientation = UIDevice.current.orientation
    
    @Published var isScaleAnimated   = false
    @Published var isLineAnimated    = false
    @Published var isCurveAnimating  = false
    @Published var isDetailViewShown = false
    
    @Published var angle: CGFloat         = 0
    @Published var previousAngle: CGFloat = 0
    @Published var currentAngle: CGFloat  = 0
    @Published var isCurved               = false
    @Published var curveRatio: CGFloat    = 0
    
    @Published var depositVertex: DepositVertex? = nil
    
    var animationWorkItem: DispatchWorkItem? = nil
    let unit: CGFloat = 40
    
    let curveSize  = CGSize(width: 190, height: 50)
    let curveUnit  = CGFloat.pi / 6
    let curveCount = 12
    
    var controlPointAngle: CGFloat {
        atan2(curveSize.width / 2, curveSize.height)
    }
    
    // MARK: Private
    private var frames = [CGRect]()
    private var highlightedVertex: Vertex? = nil
    
    private let curveAnimationDuration: TimeInterval = 0.2
    private let rotaionDuration: TimeInterval = 120
    private var size: CGSize = .zero
    
    
    // MARK: - Function
    // MARK: Public
    func request(size: CGSize) {
        guard let url = Bundle.main.url(forResource: "graph", withExtension: "json") else { return }
        self.size = size
        
        do {
            let data = try JSONDecoder().decode(GraphResponse.self, from: try Data(contentsOf: url))
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            var vertexes      = [Vertex]()
            var vertexIndices = [Int]()
            var frames        = [CGRect]()
            
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
            let userVertex = UserVertex(data: data.user, point: .zero)
            vertexes.append(userVertex)
            vertexIndices.append(vertexIndices.count)
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
                    vertexIndices.append(vertexIndices.count)
                    
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                    
                case let data as CardNode:
                    let point  = CGPoint(x: unit * 3, y: 0)
                    let vertex = CardVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as InsuranceNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 8
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = InsuranceVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as MobileNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 5
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = MobileVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as CoworkerNode:
                    let radius = unit * 6
                    let radian = CGFloat.pi / 6 * 10
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = CoworkerVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                default:
                    continue
                }
            }
            
            DispatchQueue.main.async {
                self.vertexes      = vertexes
                self.vertexIndices = vertexIndices
                self.edges         = edges
                self.frames        = frames
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
                withAnimation(Animation.linear(duration: self.rotaionDuration).repeatForever(autoreverses: false)) {
                    self.angle = -2 * .pi
                }
            }
        }
    }
    
    func handle(isPressed: Bool) {
        isCurved = isPressed
        
        // Animation Lock
        isCurveAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + curveAnimationDuration) {
            self.isCurveAnimating = false
        }
        
        // Cancel the rotation animation
        animationWorkItem?.cancel()
            
        // Curve animation
        switch isCurved {
        case false:
            withAnimation(.easeInOut(duration: curveAnimationDuration)) {
                curveRatio = 0
                angle      = previousAngle
            }

            // Resume the rotation animation
            let workItem = DispatchWorkItem {
                withAnimation(Animation.linear(duration: self.rotaionDuration).repeatForever(autoreverses: false)) {
                    self.angle = self.currentAngle - 2 * .pi
                }
            }
            
            animationWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + curveAnimationDuration, execute: workItem)
            
        case true:
            previousAngle = currentAngle
                        
            withAnimation(.easeInOut(duration: curveAnimationDuration)) {
                curveRatio = 1
                angle      = currentAngle - .pi / 9
            }
        }
    }
    
    func handle(status: TouchStatus) {
        switch status {
        case .moved(let frame):
            guard frames.count == vertexes.count else { return }
            
            // Cache and Reset the previous one
            let previousHighlightedVertex = highlightedVertex
            highlightedVertex = nil
            
            // Highlight vertexes
            for i in 1..<vertexes.count {
                vertexes[i].isHighlighted = frames[i].intersects(frame)
                
                // Cache for the vibration
                guard vertexes[i].isHighlighted else { continue }
                highlightedVertex = vertexes[i]
            }
            
            // Deposit Vertex
            var scale: CGFloat {
                let distance = (sqrt(pow(frame.origin.x, 2) + pow(frame.origin.y, 2))) - 80
                let ratio = 1 - (distance / 400)
                
                return min(max(ratio, 0.77), 1)
            }
            
            depositVertex?.scale         = scale
            depositVertex?.isHighlighted = highlightedVertex != nil
            
            // Effect
            guard let highlightedVertex = highlightedVertex, highlightedVertex.nodeID != previousHighlightedVertex?.nodeID  else { return }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            AudioServicesPlaySystemSound(1465) //1057  1113  1114  1465
            
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
                withAnimation(Animation.linear(duration: self.rotaionDuration).repeatForever(autoreverses: false)) {
                    self.angle = self.currentAngle - 2 * .pi
                }
            }
            
            // Sounds
            AudioServicesPlaySystemSound(1262)
        }
    }
    
    func update(noitfication: NotificationCenter.Publisher.Output, size: CGSize) {
        let orientation = (noitfication.object as? UIDevice)?.orientation ?? .landscapeLeft
        guard self.orientation != orientation else { return }
        
        // Stop animations
        update(isAnimated: false)
        
        // Update views
        self.orientation = orientation
        
        // Start animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.request(size: size)
            self.update(isAnimated: true)
        }
    }
    
    func addDeposit() {
        // Stop Rotation
        withAnimation(.easeOut(duration: 0.38)) {
            angle = currentAngle - ((.pi / 180) / (360 / CGFloat(rotaionDuration)))
        }
        
        // Update frames
        for (i, frame) in frames.enumerated() {
            frames[i].origin = frame.origin.applying(CGAffineTransform(rotationAngle: -angle))
        }
        
        // Add a deposit vertex
        depositVertex = DepositVertex(nodeID: "deposit1", name: "₩50,000", priority: 4, point: CGPoint(x: 45, y: 45), isHighlighted: false, scale: 1)
        
        // Ripples
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            AudioServicesPlaySystemSound(1433)
            self.vertexes[0].isHighlighted = true
        }
        
        // Repeat sounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
                switch (self?.vertexes[0].isHighlighted ?? false) {
                case true:      AudioServicesPlaySystemSound(1433)  // 1363, 1433
                case false:     timer.invalidate()
                }
            }
        }
    }
    
    func edgeAnimation(index: Int) -> Animation? {
        guard !isCurveAnimating else { return .easeInOut(duration: curveAnimationDuration) }
        return isLineAnimated ? .easeInOut(duration: 0.38).delay(0.1 + 0.1 * TimeInterval(index)) : nil
    }
    
    func dismiss() {
        // Stop rotation
        withAnimation(.linear(duration: 0.1)) {
            angle = currentAngle - ((.pi / 180) / (360 / CGFloat(rotaionDuration)))
        }
            
        withAnimation(.easeInOut(duration: 0.32)) {
            // Vertexes
            for (i, vertex) in vertexes.enumerated() {
                switch vertex {
                case is UserVertex:     continue
                default:                vertexes[i].point = .zero
                }
            }
            
            // Edges
            for (i, edge) in edges.enumerated() {
                var edge = edge
                edge.source.point = .zero
                edge.target.point = .zero
                edge.center       = .zero
                
                edges[i] = edge
            }
        }
        
        // Remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Remove vertexes
            if let first = self.vertexes.first {
                self.vertexIndices = [0]

                // Remove the user vertex after updating the graph
                DispatchQueue.main.async { self.vertexes = [first] }
                
                // Move the user vertex
                DispatchQueue.main.async {
                    let radius: CGFloat = 100
                    
                    withAnimation(.easeInOut(duration: 0.38)) {
                        self.vertexes[0].point = CGPoint(x: radius - self.size.width / 2, y: radius - self.size.height / 2)
                    }
                }
            }
            
            // Remove edges
            self.edges.removeAll()
        }
    }
}
