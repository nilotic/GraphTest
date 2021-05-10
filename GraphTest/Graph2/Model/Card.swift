// 
//  Card.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Card: Decodable, Identifiable, Vertex {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}

extension Card: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Card: Equatable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}
