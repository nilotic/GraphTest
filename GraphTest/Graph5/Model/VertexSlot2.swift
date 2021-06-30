// 
//  VertexSlot2.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexSlot2 {
    let id: UInt
    let orbit: UInt
    let line: UInt
}

extension VertexSlot2 {
    
    var point: CGPoint {
        CGPoint(x: radius * cos(angle), y: radius * sin(angle))
    }
    
    var radius: CGFloat {
        let unit: CGFloat = 20
        
        switch orbit {
        case 0:     return unit * 7
        case 1:     return unit * 8
        case 2:     return unit * 9
        default:    return unit * 7
        }
    }
    
    var angle: CGFloat {
        return CGFloat(line) * (.pi / 18)
    }
}

#if DEBUG
extension VertexSlot2 {
    
    static var placeholder: VertexSlot2 {
        VertexSlot2(id: 0, orbit: 0, line: 0)
    }
}
#endif
