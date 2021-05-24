// 
//  GraphEdge.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct GraphEdge {
    let source: Vertex
    let target: Vertex
    let center: CGPoint
}

extension GraphEdge: Identifiable {
    
    var id: String {
        "\(source.id)\(source.name)\(target.id)\(target.name)"
    }
}

extension GraphEdge: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension GraphEdge: Equatable {
    
    static func ==(lhs: GraphEdge, rhs: GraphEdge) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension GraphEdge {
    
    static var placeholder: GraphEdge {
        GraphEdge(source: UserVertex.placeholder, target: BankVertex.placeholder, center: .zero)
    }
}
#endif
