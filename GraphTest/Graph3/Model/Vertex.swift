// 
//  Vertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

protocol Vertex {
    var id: String { get }
    var nodeID: String { get }
    var name: String { get }
    var imageName: String? { get }
    var priority: UInt { get set }
    var point: CGPoint { get set }
    var isHighlighted: Bool { get set }
    var isScaled: Bool { get set }
    var angle: CGFloat { get set }
    var endAngle: CGFloat { get set }
}
