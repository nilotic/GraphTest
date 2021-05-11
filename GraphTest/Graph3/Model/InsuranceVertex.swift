// 
//  InsuranceVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct InsuranceVertex: Vertex, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let point: CGPoint
}

extension InsuranceVertex {
    
    init(data: InsuranceNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension InsuranceVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension InsuranceVertex: Equatable {
    
    static func ==(lhs: InsuranceVertex, rhs: InsuranceVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension InsuranceVertex {
    
    static var placeholder: InsuranceVertex {
        InsuranceVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
