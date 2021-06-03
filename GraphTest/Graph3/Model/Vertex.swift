// 
//  Vertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

protocol Vertex {
    var id: String { get }
    var name: String { get }
    var imageName: String? { get }
    var priority: UInt { get }
    var point: CGPoint { get }
    var isHighlighted: Bool { get set }
}
