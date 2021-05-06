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
    let data = GraphData()
    
   
    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        setWorld()
    }
    
    override func update(_ currentTime: TimeInterval) {
        data.update()
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func setWorld() {
        scene?.backgroundColor = .clear
        
        #if DEBUG
        // scene?.view?.showsFields = true
        // scene?.view?.showsFPS   = true
        #endif
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // Gravity
        physicsWorld.gravity = .zero
        addChild(data.gravityField)        
        
        // Links
        addChild(data.links)
        addChild(data.line)
    }
    
    
    // MARK: - Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        data.line.isHidden = !data.isConnecting
        
        switch node {
        case is SKShapeNode, is SKSpriteNode, is SKLabelNode:
            data.hold(node: node)
        
        default:
            guard !data.isConnecting else { return }
            let circleNode = data.circleNode
            circleNode.position = location
            
            addChild(circleNode)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let node = data.sourceNode, let location = touches.first?.location(in: self) else { return }
        
        switch data.isConnecting {
        case true:
            let path = CGMutablePath()
            path.move(to: node.position)
            path.addLine(to: location)
            
            data.line.path = path
            
        case false:
            node.run(SKAction.move(to: location, duration: 0.1))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch data.isConnecting {
        case true:
            data.line.path     = nil
            data.line.isHidden = true
            
            guard let location = touches.first?.location(in: self), let joint = data.connect(to: atPoint(location)) else { return }
            scene?.physicsWorld.add(joint)
            
        case false:
            data.sourceNode = nil
        }
    }
}
