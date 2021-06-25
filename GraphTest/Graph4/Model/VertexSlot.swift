// 
//  VertexSlot.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct VertexSlot {
    let slot: UInt
    let offset: Int
}

extension VertexSlot {
    
    var point: CGPoint {
        CGPoint(x: radius * cos(radian), y: radius * sin(radian))
    }
    
    var radius: CGFloat {
        let unit: CGFloat = 20
        
        switch slot {
        case 0, 4:          return unit * 7
        case 1, 3, 5, 7:    return [unit * 7, unit * 8].randomElement() ?? unit * 7
        case 2, 6:          return [unit * 7, unit * 8, unit * 9].randomElement() ?? unit * 7
        default:            return unit * 7
        }
    }
    
    var radian: CGFloat {
        var index: Int {
            switch slot {
            case 0, 4:      return min(3, max(0, (offset...(offset + 1)).randomElement() ?? offset))
            default:        return offset
            }
        }
        
        let unit: CGFloat = .pi / 18
        
        switch slot {
        case 0:     return [unit * -1, unit * -2, unit * 1,  unit * 2][index]
        case 1:     return [unit * 3,  unit * 4,  unit * 5,  unit * 6][index]
        case 2:     return [unit * 7,  unit * 8,  unit * 10, unit * 11][index]
        case 3:     return [unit * 12, unit * 13, unit * 14, unit * 15][index]
        case 4:     return [unit * 16, unit * 17, unit * 19, unit * 20][index]
        case 5:     return [unit * 21, unit * 22, unit * 23, unit * 24][index]
        case 6:     return [unit * 25, unit * 26, unit * 28, unit * 29][index]
        case 7:     return [unit * 30, unit * 31, unit * 32, unit * 33][index]
        default:    return unit * -1
        }
    }
    
    var priority: CGFloat {
        switch slot {
        case 0, 4:          return 0
        case 1, 3, 5, 7:    return 1
        case 2, 6:          return 2
        default:            return 2
        }
    }
}

#if DEBUG
extension VertexSlot {
    
    static var placeholder: VertexSlot {
        VertexSlot(slot: 0, offset: 0)
    }
}
#endif
