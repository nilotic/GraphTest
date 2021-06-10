// 
//  BankVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct BankVertex: Vertex {
    let nodeID: String
    let name: String
    let imageName: String?
    var priority: UInt    = 0
    var point: CGPoint    = .zero
    var isHighlighted     = false
    var isScaled          = false
    var scale: CGFloat    = 0
    var angle: CGFloat    = 0
    var endAngle: CGFloat = 0
}

extension BankVertex: Identifiable {
    
    var id: String {
        "\(nodeID)\(name)\(isHighlighted)"
    }
}

extension BankVertex {
    
    init(data: BankNode, point: CGPoint) {
        nodeID    = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension BankVertex: Decodable {
    
    private enum Key: String, CodingKey {
        case nodeID = "id"
        case name
        case imageName
        case priority
        case point
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { nodeID    = try container.decode(String.self,  forKey: .nodeID) }    catch { throw error }
        do { name      = try container.decode(String.self,  forKey: .name) }      catch { throw error }
        do { imageName = try container.decode(String.self,  forKey: .imageName) } catch { throw error }
        do { priority  = try container.decode(UInt.self,    forKey: .priority) }  catch { throw error }
        do { point     = try container.decode(CGPoint.self, forKey: .point) }     catch { throw error }
    }
}

extension BankVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeID)
    }
}

extension BankVertex: Equatable {
    
    static func ==(lhs: BankVertex, rhs: BankVertex) -> Bool {
        lhs.nodeID == rhs.nodeID
    }
}

#if DEBUG
extension BankVertex {
    
    static var placeholder: BankVertex {
        BankVertex(nodeID: "0", name: "SC", imageName: "sc")
    }
}
#endif
