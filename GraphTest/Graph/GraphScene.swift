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
    private weak var selectedNode: SKNode? = nil
    
    
    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        scene?.backgroundColor = .clear
        physicsWorld.gravity = .zero
        
        let gravityField = SKFieldNode.radialGravityField()
        gravityField.position        = CGPoint(x: size.width / 2, y: size.height / 2)
        gravityField.strength        = 2
        gravityField.minimumRadius   = Float(size.height / 2)
        gravityField.categoryBitMask = 2
        addChild(gravityField)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
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
                case .none:
                    break
                    
                case .vertex:
                    node.physicsBody?.fieldBitMask = 0
                    selectedNode = node
                    
                case .edge:
                    break
                }
            
            default:
                let vertex = Vertex(name: "\(order)", imageURL: nil, point: location)
                order += 1
                
                data.verticies.append(vertex)
                addChild(vertex.node)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = selectedNode, let touch = touches.first else { return }
        node.position = touch.location(in: self)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode?.physicsBody?.fieldBitMask = 2
        selectedNode = nil
    }
}
