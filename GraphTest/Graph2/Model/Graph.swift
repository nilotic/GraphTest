// 
//  Graph.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

struct Graph {
    let id: String
    let nodes: [Node]
    let type: GraphType
}

extension Graph: Decodable {
    
    private enum Key: String, CodingKey {
        case id
        case nodes
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { id = try container.decode(String.self, forKey: .id) } catch { throw error }
        
        do {
            let type = try container.decode(GraphType.self,  forKey: .type)
            self.type = type
            
            switch type {
            case .bank:         nodes = try container.decode([BankNode].self,      forKey: .nodes)
            case .card:         nodes = try container.decode([CardNode].self,      forKey: .nodes)
            case .insurance:    nodes = try container.decode([InsuranceNode].self, forKey: .nodes)
            case .mobile:       nodes = try container.decode([MobileNode].self,    forKey: .nodes)
            case .coworker:     nodes = try container.decode([CoworkerNode].self,  forKey: .nodes)
            }
            
        } catch { throw error }
    }
}

