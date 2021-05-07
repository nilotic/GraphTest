//
//  Graph1Data.swift
//
//  Created by Den Jo on 2021/05/04.
//  Copyright © nilotic. All rights reserved.
//

import SpriteKit

final class Graph1Data {
    
    // MARK: - Value
    // MARK: Public
    var isConnecting = false
    
    weak var sourceNode: SKNode? = nil
    weak var targetNode: SKNode? = nil
    
    var joints = [SKPhysicsJointSpring]()
    
    lazy var links: SKShapeNode = {
        let node = SKShapeNode()
        node.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        node.lineWidth   = 3.5
        node.zPosition   = -1
        
        return node
    }()
    
    /// Temporary line
    lazy var line: SKShapeNode = {
        let node = SKShapeNode()
        node.strokeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        node.lineWidth   = 3.5
        node.isHidden    = true
        
        return node
    }()
    
    var gravityField: SKFieldNode {
        let field = SKFieldNode.radialGravityField()
        field.strength      = 1
        field.falloff       = 0
        field.minimumRadius = 0.005
        
        return field
    }
    
    var profileImage: UIImage {
        [#imageLiteral(resourceName: "memoji1"),#imageLiteral(resourceName: "memoji2"),#imageLiteral(resourceName: "memoji3"),#imageLiteral(resourceName: "memoji4"),#imageLiteral(resourceName: "memoji5"),#imageLiteral(resourceName: "memoji6"),#imageLiteral(resourceName: "memoji7"),#imageLiteral(resourceName: "memoji8"),#imageLiteral(resourceName: "memoji9"),#imageLiteral(resourceName: "memoji10"),#imageLiteral(resourceName: "memoji11"),#imageLiteral(resourceName: "memoji12"),#imageLiteral(resourceName: "memoji13"),#imageLiteral(resourceName: "memoji14"),#imageLiteral(resourceName: "memoji15"),#imageLiteral(resourceName: "memoji16"),#imageLiteral(resourceName: "memoji17"),#imageLiteral(resourceName: "memoji18"),#imageLiteral(resourceName: "memoji19"),#imageLiteral(resourceName: "memoji20"),#imageLiteral(resourceName: "memoji21"),#imageLiteral(resourceName: "memoji22"),#imageLiteral(resourceName: "memoji23"),#imageLiteral(resourceName: "memoji24"),#imageLiteral(resourceName: "memoji25"),#imageLiteral(resourceName: "memoji26")].randomElement() ?? #imageLiteral(resourceName: "memoji1")
    }
    
    var name: String {
        ["Oliver", "Jake", "Noah", "James", "Jack", "Connor", "Liam", "John", "Harry", "Callum",
         "Mason", "Robert", "Jacob", "Michael", "Charlie", "Kyle", "William",
         "Amelia", "Margaret", "Emma", "Mary", "Olivia", "Samantha", "Olivia", "Patricia", "Isla", "Bethany",
         "Sophia", "Jennifer", "Emily", "Elizabeth", "Isabella", "Elizabeth", "Poppy", "Joanne", "Ava", "Linda"].randomElement() ?? "Oliver"
    }
    
    var circleNode: SKShapeNode {
        let degree = 0
        
        // Circle
        let shapeNode         = SKShapeNode(circleOfRadius: 55 + CGFloat(degree))
        shapeNode.fillColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        shapeNode.name        = name
        shapeNode.lineWidth   = 2
        shapeNode.strokeColor = #colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)
        
        shapeNode.physicsBody                  = SKPhysicsBody(circleOfRadius: 65 + CGFloat(degree))
        shapeNode.physicsBody?.isDynamic       = true
        shapeNode.physicsBody?.restitution     = 0
        shapeNode.physicsBody?.friction        = 0.3
        shapeNode.physicsBody?.linearDamping   = 0.5
        shapeNode.physicsBody?.allowsRotation  = false
        shapeNode.physicsBody?.categoryBitMask = GraphCategory.vertex.rawValue
        
        // Image
        let imageNode = SKSpriteNode(texture: SKTexture(image: profileImage))
        imageNode.size     = CGSize(width: 98, height: 98)
        imageNode.position = CGPoint(x: 0, y: 10)
        shapeNode.addChild(imageNode)
        
        // Label
        let labelNode       = SKLabelNode()
        labelNode.text      = shapeNode.name
        labelNode.position  = CGPoint(x: 0, y: -37)
        labelNode.fontName  = "Avenir-Black"
        labelNode.fontSize  = 12
        labelNode.fontColor = .white
        labelNode.verticalAlignmentMode   = .center
        labelNode.horizontalAlignmentMode = .center
        shapeNode.addChild(labelNode)
        
        return shapeNode
    }
    
    
    // MARK: - Function
    // MARK: Public
    func update() {
        guard !joints.isEmpty else { return }
        let path = CGMutablePath()
        
        for joint in joints {
            guard let source = joint.bodyA.node, let target = joint.bodyB.node else { continue }
            path.move(to: source.position)
            path.addLine(to: target.position)
            path.closeSubpath()
        }
        
        links.path = path
    }
    
    func hold(node: SKNode?) {
        var shapeNode: SKShapeNode? {
            switch node {
            case let node as SKShapeNode:   return node
            case let node as SKSpriteNode:  return node.parent as? SKShapeNode
            case let node as SKLabelNode:   return node.parent as? SKShapeNode
            default:                        return nil
            }
        }
        
        guard let node = shapeNode else { return }
        
        switch GraphCategory(rawValue: node.physicsBody?.categoryBitMask ?? 0) ?? .none {
        case .none:     break
        case .vertex:   sourceNode = node
        case .edge:     break
        }
    }
    
    func connect(to node: SKNode?) ->  SKPhysicsJointSpring? {
        var shapeNode: SKShapeNode? {
            switch node {
            case let node as SKShapeNode:   return node
            case let node as SKSpriteNode:  return node.parent as? SKShapeNode
            case let node as SKLabelNode:   return node.parent as? SKShapeNode
            default:                        return nil
            }
        }
        
        guard let source = sourceNode, let target = shapeNode, let sourceBody = source.physicsBody, let targetBody = target.physicsBody,
              GraphCategory(rawValue: targetBody.categoryBitMask) == .vertex else { return nil }
        
        // joint
        let joint = SKPhysicsJointSpring.joint(withBodyA: sourceBody, bodyB: targetBody, anchorA: source.position, anchorB: target.position)
        joint.damping   = 0.3
        joint.frequency = 0.8
        
        joints.append(joint)
        
        // Path
        let path = CGMutablePath()
        path.move(to: source.position)
        path.addLine(to: target.position)
        links.path = path
        
        return joint
    }
}
