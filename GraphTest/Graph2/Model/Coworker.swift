// 
//  Coworker.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Coworker: Decodable, Identifiable, Vertex {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension Coworker: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Coworker: Equatable {
    
    static func ==(lhs: Coworker, rhs: Coworker) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension Coworker {
    
    static var placeholder: Coworker {
        Coworker(id: "0", name: "Elizabeth", imageName: "memoji11", priority: 0)
    }
}
#endif
