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
    @Published var dashEdges     = [GraphEdge]()
    @Published var edges         = [GraphEdge]()
    @Published var thumbnails    = [UserVertex]()
    
    @Published var orientation = UIDevice.current.orientation
    @Published var isCurveAnimating  = false
    @Published var isDetailViewShown = false
    @Published var isCurved          = false
    

    @Published var depositVertex: DepositVertex? = nil
    @Published var isGraphHidden = false
    
    
    var animationWorkItem: DispatchWorkItem? = nil
    let unit: CGFloat = 40
    
    let curveUnit  = CGFloat.pi / 6
    let curveCount = 12
    
    var controlPointAngle: CGFloat {
        atan2(curveSize.width / 2, curveSize.height)
    }
    
    // MARK: Private
    private var frames = [CGRect]()
    private var highlightedVertex: Vertex? = nil
    
    private let curveSize = CGSize(width: 190, height: 50)
    
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
            let dashStyle = StrokeStyle(lineWidth: 2, lineCap: .round, dash: [0.5, 5])
            let lineStyle = StrokeStyle(lineWidth: 2)
            
            var dashEdges = [GraphEdge]()
            var edges     = [GraphEdge]()
            
            let dashEdgeColor = Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            let edgeColor     = Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
            
            for graph in data.user.graphs {
                guard let vertex = graph.nodes.sorted(by: { $0.priority < $1.priority }).first else { continue }

                switch vertex {
                case let data as BankNode:
                    let point  = CGPoint(x: 0, y: unit * 6)
                    let vertex = BankVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    dashEdges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: dashEdgeColor, style: dashStyle))
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: edgeColor, style: lineStyle))
                    
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as CardNode:
                    let point  = CGPoint(x: unit * 3, y: 0)
                    let vertex = CardVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    dashEdges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: dashEdgeColor, style: dashStyle))
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: edgeColor, style: lineStyle))
                    
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as InsuranceNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 8
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = InsuranceVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    dashEdges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: dashEdgeColor, style: dashStyle))
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: edgeColor, style: lineStyle))
                    
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as MobileNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 5
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = MobileVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    dashEdges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: dashEdgeColor, style: dashStyle))
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: edgeColor, style: lineStyle))
                    
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                case let data as CoworkerNode:
                    let radius = unit * 6
                    let radian = CGFloat.pi / 6 * 10
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = CoworkerVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    vertexIndices.append(vertexIndices.count)
                    
                    dashEdges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: dashEdgeColor, style: dashStyle))
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center, size: curveSize, color: edgeColor, style: lineStyle))
                    
                    frames.append(CGRect(origin: point, size: vertexSize(data.priority)))
                    
                default:
                    continue
                }
            }
            
            DispatchQueue.main.async {
                self.vertexes      = vertexes
                self.vertexIndices = vertexIndices
                self.dashEdges     = dashEdges
                self.edges         = edges
                self.frames        = frames
            }
    
        } catch {
            log(.error, error.localizedDescription)
        }
    }
    
    func requestThumbnails() {
        var profileImage: String {
            ["memoji1","memoji2","memoji3","memoji4","memoji5","memoji6","memoji7","memoji8","memoji9","memoji10",
             "memoji11","memoji12","memoji13","memoji14","memoji15","memoji16","memoji17","memoji18","memoji19","memoji20",
             "memoji21","memoji22","memoji23","memoji24","memoji25","memoji26"].randomElement() ?? "memoji1"
        }
        
        var name: String {
            ["Oliver", "Jake", "Noah", "James", "Jack", "Connor", "Liam", "John", "Harry", "Callum",
             "Mason", "Robert", "Jacob", "Jacob", "Jacob", "Michael", "Charlie", "Kyle", "William", "William",
             "Amelia", "Margaret", "Emma", "Mary", "Olivia", "Samantha", "Olivia", "Patricia", "Isla", "Bethany",
             "Sophia", "Jennifer", "Emily", "Elizabeth", "Isabella", "Elizabeth", "Poppy", "Joanne", "Ava", "Linda"].randomElement() ?? "Oliver"
        }
        
        var nodeID: String {
            "\((1..<100).randomElement() ?? 0)"
        }
        
        var thumbnails = [UserVertex]()
        for i in 0..<10  {
            switch i {
            case 1:     thumbnails.append(UserVertex(nodeID: nodeID, name: name, imageName: "memoji27", priority: 8, point: .zero, isHighlighted: false))
            default:    thumbnails.append(UserVertex(nodeID: nodeID, name: name, imageName: profileImage, priority: 8, point: .zero, isHighlighted: false))
            }
        }
        
        DispatchQueue.main.async {
            self.thumbnails = thumbnails
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.isGraphHidden = true
        }
    }
    
    func update(isAnimated: Bool) {
        switch isAnimated {
        case false:
            update(angle: 0)
            
            for i in 0..<vertexes.count {
                vertexes[i].isScaled = false
                vertexes[i].isHighlighted = false
            }
            
            for i in 0..<dashEdges.count {
                dashEdges[i].trim = 0...0
            }
            
            depositVertex = nil
            
            
        case true:
            // User
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard self.vertexes.first is UserVertex else { return }
                self.vertexes[0].isScaled = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                // Dash Edge
                for i in 0..<self.dashEdges.count {
                    self.dashEdges[i].trim    = 0...1
                    self.dashEdges[i].opacity = 1
                }
                
                // Vertexes
                for (i, vertex) in self.vertexes.enumerated() {
                    guard !(vertex is UserVertex), i < self.vertexes.count else { continue }
                    let duration = self.dashEdgeAnimationDuration(index: i - 1) + (0.1 + 0.2 * TimeInterval(i - 1))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        self.vertexes[i].isScaled = true
                    }
                }
            
                // Edge
                for i in 0..<self.edges.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        self.edges[i].trim    = 0...1
                        self.edges[i].opacity = 1
                    }
                    
                    // Hide dashEdge
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        guard i < self.dashEdges.count else { return }
                        self.dashEdges[i].trim    = 0...0
                        self.dashEdges[i].opacity = 0
                    }
                }
            
                // Rotation
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(Animation.linear(duration: self.rotaionDuration).repeatForever(autoreverses: false)) {
                        self.update(angle: -2 * .pi)
                    }
                }
            }
        }
    }
    
    func handle(isPressed: Bool) {
        // Animation Lock
        isCurveAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + curveAnimationDuration) {
            self.isCurveAnimating = false
        }
        
        // Cancel the rotation animation
        animationWorkItem?.cancel()
            
        // Curve animation
        switch isPressed {
        case false:
            withAnimation(.easeInOut(duration: curveAnimationDuration)) {
                update(offset: .pi / 8, curveRatio: 0)
            }

            // Resume the rotation animation
            let workItem = DispatchWorkItem {
                withAnimation(Animation.linear(duration: self.rotaionDuration).repeatForever(autoreverses: false)) {
                    self.update(offset: -2 * .pi)
                }
            }
            
            animationWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + curveAnimationDuration, execute: workItem)
            
        case true:
            withAnimation(.easeInOut(duration: curveAnimationDuration)) {
                update(offset: -.pi / 8, curveRatio: 1)
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
                    self.update(offset: -2 * .pi)
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
  
    func update(angle: CGFloat) {
        guard vertexes.count == (edges.count + 1), vertexes.first is UserVertex else { return }
        
        for i in 0..<edges.count {
            vertexes[i + 1].endAngle = angle
            edges[i].angle = -Double(vertexes[i + 1].endAngle)
        }
    }
    
    func update(offset: CGFloat, curveRatio: CGFloat = 0) {
        guard vertexes.count == (edges.count + 1), vertexes.first is UserVertex else { return }
    
        for i in 0..<edges.count {
            vertexes[i + 1].endAngle = vertexes[i + 1].angle + offset
            
            edges[i].angle = -Double(vertexes[i + 1].endAngle)
            edges[i].ratio = curveRatio
        }
    }
    
    func addDeposit() {
        // Stop Rotation
        withAnimation(.easeOut(duration: 0.38)) {
            update(offset: -((.pi / 180) / (360 / CGFloat(rotaionDuration))))
        }
        
        // Update frames
        guard frames.count == vertexes.count else { return }
        for (i, frame) in frames.enumerated() {
            frames[i].origin = frame.origin.applying(CGAffineTransform(rotationAngle: -vertexes[i].endAngle))
        }
        
        // Add a deposit vertex
        depositVertex = DepositVertex(nodeID: "deposit1", name: "₩50,000", priority: 4, point: CGPoint(x: 45, y: 45), isHighlighted: false, scale: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.depositVertex?.isScaled = true
        }
        
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
    
    func dashEdgeAnimation(index: Int) -> Animation? {
        guard !isCurveAnimating else { return .easeInOut(duration: curveAnimationDuration) }
        let duration = dashEdgeAnimationDuration(index: index)
        return dashEdges[index].trim.upperBound <= 0 ? nil : .easeInOut(duration: duration).delay(0.1 + 0.2 * TimeInterval(index))
    }
    
    func dashEdgeAnimationDuration(index: Int) -> TimeInterval {
        guard !isCurveAnimating, index < vertexes.count, index < dashEdges.count else { return 0 }
        let point = vertexes[index].point
        let distance = sqrt(pow(point.x, 2) + pow(point.y, 2))
        let ratio = TimeInterval(distance / min(size.width, size.height))
    
        return 0.3 + max(0.38, ratio)
    }
    
    func edgeAnimation(index: Int) -> Animation? {
        guard !isCurveAnimating else { return .easeInOut(duration: curveAnimationDuration) }
        guard index < edges.count else { return nil }
        
        return edges[index].trim.upperBound <= 0 ? nil : .easeInOut(duration: 0.7)
    }
    
    func dismiss() {
        // Stop rotation
        withAnimation(.linear(duration: 0.1)) {
            update(offset: -((.pi / 180) / (360 / CGFloat(rotaionDuration))))
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
        
        // Shrink animation
        self.vertexes[0].priority = 2
        
        
        // Remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Remove vertexes
            if let first = self.vertexes.first {
                self.vertexIndices = [0]
                // Remove the user vertex after updating the graph
                DispatchQueue.main.async { self.vertexes = [first] }
                
                // Move the user vertex
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.vertexes[0].point = CGPoint(x: 95 - self.size.width / 2, y: 30 - self.size.height / 2)
                    self.vertexes[0].priority = 8
                }
            }
            
            // Remove edges
            self.dashEdges.removeAll()
            self.edges.removeAll()
        }
        
        
        // Thumbnail
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                self.requestThumbnails()
            }
        }
    }
}
