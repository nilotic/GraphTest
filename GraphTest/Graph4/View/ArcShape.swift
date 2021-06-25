// 
//  ArcShape.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct ArcShape: Shape {
    
    // MARK: - Value
    // MARK: Public
    let startAngle: Angle
    let endAngle: Angle

    
    // MARK: - Function
    // MARK: Public
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        return path
    }
}
