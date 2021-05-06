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
    private var order: UInt = 0
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
    
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        switch isConnecting {
        case true:
            break
            
        case false:
            switch atPoint(location) {
            case let node as SKShapeNode:
                switch GraphCategory(rawValue: node.physicsBody?.categoryBitMask ?? 0) ?? .none {
                case .none:     break
                case .vertex:   selectedVertex = node
                case .edge:     break
                }
                
            case let node as SKLabelNode:
                selectedVertex = node.parent
            
            default:
                let vertex = Vertex(name: "\(order)", imageURL: nil, point: location)
                order += 1
                
                data.verticies.append(vertex)
                addChild(vertex.node)
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
