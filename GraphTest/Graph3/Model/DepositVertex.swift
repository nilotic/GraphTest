// 
//  DepositVertex.swift
//
//  Created by Den Jo on 2021/06/01.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct DepositVertex: Vertex, Identifiable {
    let id: String
    let name: String
    var imageName: String?
    let priority: UInt
    let point: CGPoint
}

extension DepositVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension DepositVertex: Equatable {
    
    static func ==(lhs: DepositVertex, rhs: DepositVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension DepositVertex {
    
    static var placeholder: DepositVertex {
        DepositVertex(id: "0", name: "₩50,000", priority: 0, point: .zero)
    }
}
#endif
