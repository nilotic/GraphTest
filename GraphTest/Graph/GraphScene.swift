//
//  GraphScene.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SpriteKit

final class GraphScene: SKScene {
    
    // MARK: - Value
    // MARK: Public
    var isConnecting = false
    
    // MARK: Private
    private let data = GraphData()
    private weak var selectedVertex: SKNode? = nil
    
    
    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        setWorld()
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func setWorld() {
        scene?.backgroundColor = .clear
        physicsWorld.gravity = .zero
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // Gravity
        let gravityField = SKFieldNode.radialGravityField()
        gravityField.position      = .zero
        gravityField.strength      = 1
        gravityField.falloff       = 0
        gravityField.minimumRadius = 0.005
        
        addChild(gravityField)
    }
    
    private func add(position: CGPoint) {
        var profileImage: UIImage {
            [#imageLiteral(resourceName: "memoji1"),#imageLiteral(resourceName: "memoji2"),#imageLiteral(resourceName: "memoji3"),#imageLiteral(resourceName: "memoji4"),#imageLiteral(resourceName: "memoji5"),#imageLiteral(resourceName: "memoji6"),#imageLiteral(resourceName: "memoji7"),#imageLiteral(resourceName: "memoji8"),#imageLiteral(resourceName: "memoji9"),#imageLiteral(resourceName: "memoji10"),#imageLiteral(resourceName: "memoji11"),#imageLiteral(resourceName: "memoji12"),#imageLiteral(resourceName: "memoji13"),#imageLiteral(resourceName: "memoji14"),#imageLiteral(resourceName: "memoji15"),#imageLiteral(resourceName: "memoji16"),#imageLiteral(resourceName: "memoji17"),#imageLiteral(resourceName: "memoji18"),#imageLiteral(resourceName: "memoji19"),#imageLiteral(resourceName: "memoji20"),#imageLiteral(resourceName: "memoji21"),#imageLiteral(resourceName: "memoji22"),#imageLiteral(resourceName: "memoji23"),#imageLiteral(resourceName: "memoji24"),#imageLiteral(resourceName: "memoji25"),#imageLiteral(resourceName: "memoji26")].randomElement() ?? #imageLiteral(resourceName: "memoji1")
        }
        
        var name: String {
            ["Oliver", "Jake", "Noah", "James", "Jack", "Connor", "Liam", "John", "Harry", "Callum",
             "Mason", "Robert", "Jacob", "Jacob", "Jacob", "Michael", "Charlie", "Kyle", "William", "William",
             "Amelia", "Margaret", "Emma", "Mary", "Olivia", "Samantha", "Olivia", "Patricia", "Isla", "Bethany",
             "Sophia", "Jennifer", "Emily", "Elizabeth", "Isabella", "Elizabeth", "Poppy", "Joanne", "Ava", "Linda"].randomElement() ?? "Oliver"
        }
        
        let degree = 1
    
        var circleNode: SKShapeNode {
           // Circle
            let shapeNode         = SKShapeNode(circleOfRadius: 55 + CGFloat(degree))
            shapeNode.name        = name
            shapeNode.position    = position
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
        
        addChild(circleNode)
    }
    
    private func hold(node: SKNode?) {
        guard let node = node as? SKShapeNode else { return }
        
        switch GraphCategory(rawValue: node.physicsBody?.categoryBitMask ?? 0) ?? .none {
        case .none:     break
        case .vertex:   selectedVertex = node
        case .edge:     break
        }
    }
    
    
    // MARK: - Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        switch isConnecting {
        case true:
            break
            
        case false:
            switch atPoint(location) {
            case let node as SKShapeNode:                                       hold(node: node)
            case let node as SKSpriteNode where node.parent is SKShapeNode:     hold(node: node.parent)
            case let node as SKLabelNode where node.parent is SKShapeNode:      hold(node: node.parent)
            default:                                                            add(position: location)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = selectedVertex, let location = touches.first?.location(in: self) else { return }
        node.run(SKAction.move(to: location, duration: 0.1))
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedVertex = nil
    }
}
