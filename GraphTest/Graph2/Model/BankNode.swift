// 
//  BankNode.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct BankNode: Node, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension BankNode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension BankNode: Equatable {
    
    static func ==(lhs: BankNode, rhs: BankNode) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension BankNode {
    
    static var placeholder: BankNode {
        BankNode(id: "0", name: "SC", imageName: "sc", priority: 0)
    }
}
#endif
