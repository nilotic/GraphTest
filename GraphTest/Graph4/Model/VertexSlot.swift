// 
//  VertexSlot.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexSlot {
    let slot: UInt
    let line: UInt
}

extension VertexSlot {
    
    var point: CGPoint {
        CGPoint(x: radius * cos(angle), y: radius * sin(angle))
    }
    
    var priority: UInt {
        switch slot {
        case 0, 4:          return 0
        case 1, 3, 5, 7:    return 1
        case 2, 6:          return 2
        default:            return 2
        }
    }
    
    var angle: CGFloat {
        return CGFloat(line) * (.pi / 18)
    }
    
    var radius: CGFloat {
        let unit: CGFloat = 20
        
        switch slot {
        case 0, 4:          return unit * 7
        case 1, 3, 5, 7:    return unit * 8
        case 2, 6:          return unit * 9
        default:            return unit * 7
        }
    }
}

#if DEBUG
extension VertexSlot {

    static var placeholder: VertexSlot {
        VertexSlot(slot: 0, line: 1)
    }
}
#endif
