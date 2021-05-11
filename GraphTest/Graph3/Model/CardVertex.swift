// 
//  CardVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CardVertex: Vertex, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let point: CGPoint
}

extension CardVertex {
    
    init(data: CardNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension CardVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CardVertex: Equatable {
    
    static func ==(lhs: CardVertex, rhs: CardVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension CardVertex {
    
    static var placeholder: CardVertex {
        CardVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
