// 
//  InsuranceNode.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct InsuranceNode: Decodable, Identifiable, Node {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension InsuranceNode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension InsuranceNode: Equatable {
    
    static func ==(lhs: InsuranceNode, rhs: InsuranceNode) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension InsuranceNode {
    
    static var placeholder: InsuranceNode {
        InsuranceNode(id: "0", name: "AIG", imageName: "aig", priority: 0)
    }
}
#endif
