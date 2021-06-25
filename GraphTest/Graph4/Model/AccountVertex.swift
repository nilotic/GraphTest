// 
//  AccountVertex.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct AccountVertex: Identifiable {
    let id: String
    let name: String
    let imageName: String
    let slot: VertexSlot
}

extension AccountVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AccountVertex: Equatable {
    
    static func ==(lhs: AccountVertex, rhs: AccountVertex) -> Bool {
        lhs.id == rhs.id
    }
}


#if DEBUG
extension AccountVertex {
    
    static var placeholder: AccountVertex {
        AccountVertex(id: "0", name: "Oliver", imageName: "memoji1", slot: .placeholder)
    }
}
#endif
