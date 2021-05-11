// 
//  UserNode.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct UserNode: Node, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let graphs: [Graph]
}

extension UserNode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UserNode: Equatable {
    
    static func ==(lhs: UserNode, rhs: UserNode) -> Bool {
        lhs.id == rhs.id
    }
}


#if DEBUG
extension UserNode {
    
    static var placeholder: UserNode {
        UserNode(id: "0", name: "Oliver", imageName: "memoji1", priority: 0, graphs: [])
    }
}
#endif
