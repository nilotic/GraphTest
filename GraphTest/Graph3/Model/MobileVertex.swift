// 
//  MobileVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct MobileVertex: Vertex, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let point: CGPoint
}

extension MobileVertex {
    
    init(data: MobileNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension MobileVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MobileVertex: Equatable {
    
    static func ==(lhs: MobileVertex, rhs: MobileVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension MobileVertex {
    
    static var placeholder: MobileVertex {
        MobileVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
