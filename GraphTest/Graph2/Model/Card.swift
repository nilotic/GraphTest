// 
//  Card.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

struct Card: Vertex, Decodable {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
}
