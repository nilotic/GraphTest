// 
//  Insurance.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Insurance: Decodable, Identifiable, Vertex {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension Insurance: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Insurance: Equatable {
    
    static func ==(lhs: Insurance, rhs: Insurance) -> Bool {
        lhs.id == rhs.id
    }
}
