// 
//  MobileNode.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

struct MobileNode: Node, Decodable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension MobileNode: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MobileNode: Equatable {
    
    static func ==(lhs: MobileNode, rhs: MobileNode) -> Bool {
        lhs.id == rhs.id
    }
}

extension MobileNode {
    
    static var placeholder: MobileNode {
        MobileNode(id: "0", name: "at&t", imageName: "at&t", priority: 0)
    }
}
