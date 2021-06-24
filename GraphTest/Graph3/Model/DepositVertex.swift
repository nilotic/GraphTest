// 
//  DepositVertex.swift
//
//  Created by Den Jo on 2021/06/01.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct DepositVertex: Vertex {
    let nodeID: String
    let name: String
    var imageName: String?
    var priority: UInt    = 0
    var point: CGPoint    = .zero
    var isHighlighted     = false
    var isScaled          = false
    var scale: CGFloat    = 0
    var angle: CGFloat    = 0
    var endAngle: CGFloat = 0
    var blur: CGFloat     = 0
}

extension DepositVertex: Identifiable {
    
    var id: String {
        "\(nodeID)\(name)\(isHighlighted)"
    }
}

extension DepositVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeID)
    }
}

extension DepositVertex: Equatable {
    
    static func ==(lhs: DepositVertex, rhs: DepositVertex) -> Bool {
        lhs.nodeID == rhs.nodeID
    }
}

#if DEBUG
extension DepositVertex {
    
    static var placeholder: DepositVertex {
        DepositVertex(nodeID: "0", name: "₩50,000")
    }
}
#endif
