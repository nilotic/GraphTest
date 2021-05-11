// 
//  Bank.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Bank: Decodable, Identifiable, Vertex {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension Bank: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Bank: Equatable {
    
    static func ==(lhs: Bank, rhs: Bank) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension Bank {
    
    static var placeholder: Bank {
        Bank(id: "0", name: "SC", imageName: "sc", priority: 0)
    }
}
#endif
