// 
//  CoworkerNode.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CoworkerNode: Node, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension CoworkerNode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CoworkerNode: Equatable {
    
    static func ==(lhs: CoworkerNode, rhs: CoworkerNode) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension CoworkerNode {
    
    static var placeholder: CoworkerNode {
        CoworkerNode(id: "0", name: "Elizabeth", imageName: "memoji11", priority: 0)
    }
}
#endif
