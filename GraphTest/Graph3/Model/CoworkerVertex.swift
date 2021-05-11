// 
//  CoworkerVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CoworkerVertex: Vertex, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let point: CGPoint
}

extension CoworkerVertex {
    
    init(data: CoworkerNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension CoworkerVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CoworkerVertex: Equatable {
    
    static func ==(lhs: CoworkerVertex, rhs: CoworkerVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension CoworkerVertex {
    
    static var placeholder: CoworkerVertex {
        CoworkerVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
