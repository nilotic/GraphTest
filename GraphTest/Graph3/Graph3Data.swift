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
            let length = min(size.width, size.height)
            let unit   = length / 10
            
            var edges = [GraphEdge]()
            for graph in data.user.graphs {
                guard let vertex = graph.nodes.sorted(by: { $0.priority < $1.priority }).first else { continue }

                switch vertex {
                case let data as BankNode:
                    let point  = CGPoint(x: center.x, y: center.y + unit * 6)
                    let anchor = UnitPoint(x: point.x / size.width, y: point.y / size.height)
                    let vertex = BankVertex(data: data, point: point, anchor: anchor)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex))
                    
                case let data as CardNode:
                    let point  = CGPoint(x: center.x + unit * 3, y: center.y)
                    let anchor = UnitPoint(x: point.x / size.width, y: point.y / size.height)
                    let vertex = CardVertex(data: data, point: point, anchor: anchor)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex))
                    
                case let data as InsuranceNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 8
                    let point  = CGPoint(x: center.x + radius * cos(radian), y: center.y + radius * sin(radian))
                    let anchor = UnitPoint(x: point.x / size.width, y: point.y / size.height)
                    let vertex = InsuranceVertex(data: data, point: point, anchor: anchor)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex))
                    
                case let data as MobileNode:
                    let radius = unit * 4
                    let radian = CGFloat.pi / 6 * 5
                    let point  = CGPoint(x: center.x + radius * cos(radian), y: center.y + radius * sin(radian))
                    let anchor = UnitPoint(x: point.x / size.width, y: point.y / size.height)
                    let vertex = MobileVertex(data: data, point: point, anchor: anchor)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex))
                    
                case let data as CoworkerNode:
                    let radius = unit * 6
                    let radian = CGFloat.pi / 6 * 10
                    let point  = CGPoint(x: center.x + radius * cos(radian), y: center.y + radius * sin(radian))
                    let anchor = UnitPoint(x: point.x / size.width, y: point.y / size.height)
                    let vertex = CoworkerVertex(data: data, point: point, anchor: anchor)
                    
                    vertexes.append(vertex)
                    edges.append(GraphEdge(source: userVertex, target: vertex))
                    
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
