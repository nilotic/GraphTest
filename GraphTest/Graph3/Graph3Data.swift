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
    
    @Published var isScaleAnimated      = false
    @Published var isLineAnimated       = false
    @Published var isRotationAnimated   = false
    @Published var isDetailViewShown    = false
    
    @Published var angle: CGFloat         = 0
    @Published var previousAngle: CGFloat = 0
    @Published var currentAngle: CGFloat  = 0
    @Published var isCurved               = false
    @Published var curveRatio: CGFloat    = 0
    @Published var isCurveAnimating       = false
    
    var animationWorkItem: DispatchWorkItem? = nil
    let unit: CGFloat = 40
    
    let curveSize  = CGSize(width: 190, height: 50)
    let curveUnit  = CGFloat.pi / 6
    let curveCount = 12
    
    let duration: Double = 120
    
    var controlPointAngle: CGFloat {
        atan2(curveSize.width / 2, curveSize.height)
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request(size: CGSize) {
        guard let url = Bundle.main.url(forResource: "graph", withExtension: "json") else { return }
        
        do {
            let data = try JSONDecoder().decode(GraphResponse.self, from: try Data(contentsOf: url))
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            var vertexes = [Vertex]()
            
            // User
            let userVertex = UserVertex(data: data.user, point: center)
            vertexes.append(userVertex)
            
            
            // Edge
            var edges = [GraphEdge]()
            for graph in data.user.graphs {
                guard let vertex = graph.nodes.sorted(by: { $0.priority < $1.priority }).first else { continue }

                switch vertex {
                case let data as BankNode:
                    let point  = CGPoint(x: 0, y: unit * 6)
                    let vertex = BankVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    
                case let data as CardNode:
                    let point  = CGPoint(x: unit * 3, y: 0)
                    let vertex = CardVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    
                case let data as InsuranceNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 8
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = InsuranceVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    
                case let data as MobileNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 5
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = MobileVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    
                case let data as CoworkerNode:
                    let radius = unit * 6
                    let radian = CGFloat.pi / 6 * 10
                    let point  = CGPoint(x: radius * cos(radian), y: radius * sin(radian))
                    let vertex = CoworkerVertex(data: data, point: point)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex, center: center))
                    
                default:
                    continue
                }
            }
            
            DispatchQueue.main.async {
                self.vertexes = vertexes
                self.edges    = edges
            }
    
        } catch {
            log(.error, error.localizedDescription)
        }
    }
}
