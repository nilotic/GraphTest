// 
//  Mobile.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

struct Mobile: Decodable, Identifiable, Vertex {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension Mobile: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Mobile: Equatable {
    
    static func ==(lhs: Mobile, rhs: Mobile) -> Bool {
        lhs.id == rhs.id
    }
}
