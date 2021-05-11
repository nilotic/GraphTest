// 
//  Graph2Scene.swift
//
//  Created by Den Jo on 2021/05/07.
//  Copyright © nilotic. All rights reserved.
//

import SpriteKit

final class Graph2Scene: SKScene {
    
    // MARK: - Value
    // MARK: Public
    let data = Graph2Data()
    
   
    // MARK: - View Life Cycle
    override func didMove(to view: SKView) {
        setWorld()
        setGraph()
    }
    
    override func update(_ currentTime: TimeInterval) {
        data.update()
    }
    
    
    // MARK: - Function
    // MARK: Private
    private func setWorld() {
        // Scene
        scene?.backgroundColor = .clear
        scene?.view?.showsFPS  = true
        // scene?.view?.showsFields  = true
        // scene?.view?.showsPhysics = true
        
        // Gravity
        physicsWorld.gravity = .zero
        addChild(data.gravityField)
        
        // Links
        addChild(data.links)
        addChild(data.line)
    }
    
    private func setGraph() {
        data.request()
        
        for node in data.nodes {
            addChild(node)
        }
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
            addChild(data.coworkerNode(location))
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
