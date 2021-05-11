// 
//  User.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct User: Decodable, Identifiable, Node {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let graphs: [Graph]
}

extension User: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension User: Equatable {
    
    static func ==(lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}


#if DEBUG
extension User {
    
    static var placeholder: User {
        User(id: "0", name: "Oliver", imageName: "memoji1", priority: 0, graphs: [])
    }
}
#endif
