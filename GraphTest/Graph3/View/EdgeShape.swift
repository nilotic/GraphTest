// 
//  EdgeShape.swift
//
//  Created by Den Jo on 2021/05/20.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct EdgeShape: Shape {
    
    // MARK: - Value
    // MARK: Public
    let source: CGPoint
    let target: CGPoint
    
    var isCurved: Bool = true
    
    var animatableData: Bool {
        get { isCurved }
        set { isCurved = newValue}
    }
    
    // MARK: Private
    private var angle: CGFloat {
        //    offset(x: ((curveBox.width / 2 + 12) * cos(angle + .pi/6 * CGFloat($0))), y: (curveBox.width / 2 + 12) * sin(angle + .pi/6 * CGFloat($0)))
        let degree = atan2(target.x - source.x, target.y - source.y) - .pi / 4
        return -degree
    }
    
    private var radius: CGFloat {
        let radius = sqrt(pow(target.x - source.x, 2) + pow(target.y - source.y, 2))
        return radius / 2 + 10
    }

    private var control: CGPoint {
        let point = CGPoint(x: source.x + radius * cos(angle), y: source.y + radius * sin(angle))
        log(.info, "\(point), \(angle * 180 / .pi)")
        return point
    }
    
    
    // MARK: - Function
    // MARK: Public
    func path(in rect: CGRect) -> Path {
        Path {
            $0.move(to: source)
            switch isCurved {
            case false:     $0.addLine(to: target)
            case true:      $0.addQuadCurve(to: target, control: control)
            }
        }
    }
}
