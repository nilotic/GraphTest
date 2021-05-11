// 
//  UserVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct UserVertex: Vertex, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let point: CGPoint
}

extension UserVertex {
    
    init(data: UserNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension UserVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UserVertex: Equatable {
    
    static func ==(lhs: UserVertex, rhs: UserVertex) -> Bool {
        lhs.id == rhs.id
    }
}


#if DEBUG
extension UserVertex {
    
    static var placeholder: UserVertex {
        UserVertex(id: "0", name: "Oliver", imageName: "memoji1", priority: 0, point: .zero)
    }
}
#endif
