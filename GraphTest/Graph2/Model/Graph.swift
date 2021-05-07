// 
//  Graph.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

struct Graph {
    let id: String
    let vertexes: [Vertex]
    let type: GraphType
}

extension Graph: Decodable {
    
    private enum Key: String, CodingKey {
        case id
        case vertexes
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { id = try container.decode(String.self, forKey: .id) } catch { throw error }
        
        do {
            let type = try container.decode(GraphType.self,  forKey: .type)
            self.type = type
            
            switch type {
            case .bank:         vertexes = try container.decode([Bank].self,      forKey: .vertexes)
            case .card:         vertexes = try container.decode([Card].self,      forKey: .vertexes)
            case .insurance:    vertexes = try container.decode([Insurance].self, forKey: .vertexes)
            case .mobile:       vertexes = try container.decode([Mobile].self,    forKey: .vertexes)
            case .coworker:     vertexes = try container.decode([Coworker].self,  forKey: .vertexes)
            }
            
        } catch { throw error }
    }
}

