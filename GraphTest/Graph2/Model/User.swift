// 
//  User.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

struct User: Decodable, Vertex {
    let id: String
    let name: String
    let imageName: String
    let priority: UInt
    let graphs: [Graph]
}
