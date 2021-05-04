//
//  Vertex.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SpriteKit

struct Vertex {
    let id: UUID
    let name: String
    let imageURL: URL?
    var degree: UInt    // the number of edges falling on it.
    let node: SKShapeNode
}

extension Vertex {
    
    init(name: String, imageURL: URL?, point: CGPoint) {
        id     = UUID()
        degree = 0
        
        self.imageURL = imageURL
        self.name     = name
        
        // Node
        var circleNode: SKShapeNode {
            let shapeNode                          = SKShapeNode(circleOfRadius: 35)
            shapeNode.position                     = point
            shapeNode.physicsBody                  = SKPhysicsBody(circleOfRadius: 55)
            shapeNode.physicsBody?.isDynamic       = true
            shapeNode.physicsBody?.friction        = 0.9
            shapeNode.physicsBody?.linearDamping   = 2
            shapeNode.physicsBody?.angularDamping  = 2
            shapeNode.physicsBody?.restitution     = 0.1
            shapeNode.physicsBody?.mass            = 10
            shapeNode.physicsBody?.allowsRotation  = true
            shapeNode.physicsBody?.categoryBitMask = GraphCategory.vertex.rawValue
            shapeNode.physicsBody?.fieldBitMask    = 2
            shapeNode.lineWidth                    = 2.0
            shapeNode.strokeColor                  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            shapeNode.fillColor                    = [#colorLiteral(red: 0.8941176471, green: 0.1882352941, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 1, green: 0.5019607843, blue: 0.1411764706, alpha: 1), #colorLiteral(red: 1, green: 0.7294117647, blue: 0.4823529412, alpha: 1), #colorLiteral(red: 0.5333333333, green: 0.8666666667, blue: 0.5568627451, alpha: 1), #colorLiteral(red: 0.06274509804, green: 0.6431372549, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.6549019608, green: 0.7764705882, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0, green: 0.462745098, blue: 0.6901960784, alpha: 1), #colorLiteral(red: 0.5960784314, green: 0.4078431373, blue: 0.7254901961, alpha: 1), #colorLiteral(red: 0.7764705882, green: 0.6862745098, blue: 0.8274509804, alpha: 1)].randomElement() ?? #colorLiteral(red: 0.8941176471, green: 0.1882352941, blue: 0.1764705882, alpha: 1)
            
            // Label
            let labelNode       = SKLabelNode()
            labelNode.text      = name
            labelNode.fontName  = UIFont.systemFont(ofSize: 28, weight: .bold).fontName
            labelNode.fontColor = .black
            labelNode.verticalAlignmentMode   = .center
            labelNode.horizontalAlignmentMode = .center
            shapeNode.addChild(labelNode)
            
            // Image
            if let url = imageURL {
                log(.info, url)
            }
            
            /*
            // Magnet
            let field = SKFieldNode.radialGravityField()
            field.minimumRadius = 15
            field.strength      = -0.1
            shapeNode.addChild(field)
            */
            
            return shapeNode
        }
        
        node = circleNode
    }
}
