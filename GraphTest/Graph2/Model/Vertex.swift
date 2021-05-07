// 
//  Vertex.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

protocol Vertex {
    var id: String { get }
    var name: String { get }
    var imageName: String { get }
    var priority: UInt { get }
}
