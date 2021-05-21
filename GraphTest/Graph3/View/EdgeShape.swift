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
    let size: CGSize
    var ratio: CGFloat
    
    var animatableData: CGFloat {
        get { ratio }
        set { ratio = newValue }
    }
    
    // MARK: Private
    private var control: CGPoint {
        CGPoint(x: source.x + radius * cos(controlPointAngle), y: source.y + radius * sin(controlPointAngle))
    }
    
    private var edgeAngle: CGFloat {
        atan2(target.y - source.y, target.x - source.x)
    }
    
    private var controlPointAngle: CGFloat {
        edgeAngle - atan2(size.height * ratio, size.width / 2)
    }
    
    private var radius: CGFloat {
        sqrt(pow(size.width / 2, 2) + pow(size.height * ratio, 2))
    }
    
    
    // MARK: - Function
    // MARK: Public
    func path(in rect: CGRect) -> Path {
        Path {
            $0.move(to: source)
            $0.addQuadCurve(to: target, control: control)
        }
    }
}
