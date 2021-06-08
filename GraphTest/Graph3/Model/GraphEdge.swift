// 
//  GraphEdge.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct GraphEdge {
    var source: Vertex
    var target: Vertex
    var center: CGPoint            = .zero
    var size: CGSize               = .zero
    var ratio: CGFloat             = 0
    var angle: Double              = 0
    var trim: ClosedRange<CGFloat> = 0...0
    var color: Color               = .clear
    var opacity: Double            = 0
    var style                      = StrokeStyle()
}

extension GraphEdge: Identifiable {
    
    var id: String {
        "\(source.nodeID)\(source.name)\(target.id)\(target.name)"
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
        GraphEdge(source: UserVertex.placeholder, target: BankVertex.placeholder)
    }
}
#endif
