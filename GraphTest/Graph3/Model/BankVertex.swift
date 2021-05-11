// 
//  BankVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct BankVertex: Vertex, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let point: CGPoint
}

extension BankVertex {
    
    init(data: BankNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension BankVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension BankVertex: Equatable {
    
    static func ==(lhs: BankVertex, rhs: BankVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension BankVertex {
    
    static var placeholder: BankVertex {
        BankVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
