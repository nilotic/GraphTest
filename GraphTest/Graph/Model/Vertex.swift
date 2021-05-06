//
//  Vertex.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SpriteKit

struct Vertex {
    let id = UUID()
    let name: String
    var degree: UInt  // the number of edges falling on it.
    let node: SKShapeNode
}

extension Vertex {
    
    init(name: String, degree: UInt, image: UIImage?, point: CGPoint) {
        self.name   = name
        self.degree = degree
        
        // Node
        var circleNode: SKShapeNode {
           // Circle
            let shapeNode         = SKShapeNode(circleOfRadius: 35 + CGFloat(degree))
            shapeNode.position    = point
            shapeNode.lineWidth   = 2
            shapeNode.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            shapeNode.physicsBody                  = SKPhysicsBody(circleOfRadius: 55 + CGFloat(degree))
            shapeNode.physicsBody?.isDynamic       = true
            shapeNode.physicsBody?.restitution     = 0
            shapeNode.physicsBody?.friction        = 0.3
            shapeNode.physicsBody?.linearDamping   = 0.5
            shapeNode.physicsBody?.allowsRotation  = false
            shapeNode.physicsBody?.categoryBitMask = GraphCategory.vertex.rawValue
            
            // Image
            if let image = image {
                shapeNode.addChild(SKSpriteNode(texture: SKTexture(image: image)))
            }
            
            // Label
            let labelNode       = SKLabelNode()
            labelNode.text      = name
            labelNode.fontName  = UIFont.systemFont(ofSize: 28, weight: .bold).fontName
            labelNode.fontColor = .black
            labelNode.verticalAlignmentMode   = .center
            labelNode.horizontalAlignmentMode = .center
            shapeNode.addChild(labelNode)
            
            return shapeNode
        }
        
        node = circleNode
    }
}

final class Vertex2: SKShapeNode {
    
    // MARK: - Value
    // MARK: Public
    var degree: UInt = 0
    
    
    // MARK: - Initialzer
    init(image: UIImage? = nil, position: CGPoint = .zero) {
        super.init()
        
        self.position = position
        lineWidth = 2
        strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // PhysicsBody
        physicsBody                  = SKPhysicsBody(circleOfRadius: 55 + CGFloat(degree))
        physicsBody?.isDynamic       = true
        physicsBody?.restitution     = 0
        physicsBody?.friction        = 0.3
        physicsBody?.linearDamping   = 0.5
        physicsBody?.allowsRotation  = false
        physicsBody?.categoryBitMask = GraphCategory.vertex.rawValue
        
        // Image
        if let image = image {
            addChild(SKSpriteNode(texture: SKTexture(image: image)))
        }
        
        // Label
        if let name = name, name != "" {
            let labelNode       = SKLabelNode()
            labelNode.text      = name
            labelNode.fontName  = UIFont.systemFont(ofSize: 28, weight: .bold).fontName
            labelNode.fontColor = .black
            labelNode.verticalAlignmentMode   = .center
            labelNode.horizontalAlignmentMode = .center
            addChild(labelNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
