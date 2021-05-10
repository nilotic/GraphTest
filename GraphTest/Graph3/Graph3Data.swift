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
    @Published var vertexes = [Item]()
    @Published var edges    = [GraphEdge]()
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        guard let url = Bundle.main.url(forResource: "graph", withExtension: "json") else { return }
        
        do {
            let data = try JSONDecoder().decode(GraphResponse.self, from: try Data(contentsOf: url))
            var vertexes = [Item]()

            // User
            vertexes.append(Item(data: data.user))
            

            // Graph
            let unit = CGFloat.pi * 2 / CGFloat(max(1, data.user.graphs.count))
            let radius = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 2 - 75

            for (i, graph) in data.user.graphs.enumerated() {
                guard let vertex = graph.vertexes.sorted(by: { $0.priority < $1.priority }).first else { continue }

                // Node
//                let node = vertexNode(vertex)
//                node.position = CGPoint(x: radius * cos(unit * CGFloat(i)), y: radius * sin(unit * CGFloat(i)))
//                nodes.append(node)


                // Edge
                
//                edges.append(joint)
            }
            
            DispatchQueue.main.async {
                self.vertexes = vertexes
                
            }
    
        } catch {
            log(.error, error.localizedDescription)
        }
    }
}
