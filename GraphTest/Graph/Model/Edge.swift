//
//  Edge.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SpriteKit

struct Edge {
    var source: SKNode
    var target: SKNode
    var weight: CGFloat
}

extension Edge {
    
    var jointSpring: SKPhysicsJointSpring? {
        guard let bodyA = source.physicsBody, let bodyB = target.physicsBody else {
            log(.error, "Failed to get physics bodys")
            return nil
        }
        
        let jointSpring = SKPhysicsJointSpring.joint(withBodyA: bodyA, bodyB: bodyB, anchorA: source.position, anchorB: target.position)
        jointSpring.damping   = 0.1
        jointSpring.frequency = 0.8

        return jointSpring
    }
}
