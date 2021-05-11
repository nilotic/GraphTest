// 
//  CardNode.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CardNode: Node, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension CardNode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CardNode: Equatable {
    
    static func ==(lhs: CardNode, rhs: CardNode) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension CardNode {
    
    static var placeholder: CardNode {
        CardNode(id: "0", name: "VISA", imageName: "visa", priority: 0)
    }
}
#endif
