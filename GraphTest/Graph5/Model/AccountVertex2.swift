// 
//  AccountVertex2.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct AccountVertex2: Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let slot: VertexSlot2
}

extension AccountVertex2: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AccountVertex2: Equatable {
    
    static func ==(lhs: AccountVertex2, rhs: AccountVertex2) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension AccountVertex2 {
    
    static var placeholder: AccountVertex2 {
        AccountVertex2(id: "0", name: "Oliver", imageName: "memoji1", priority: 0, slot: .placeholder)
    }
}
#endif
