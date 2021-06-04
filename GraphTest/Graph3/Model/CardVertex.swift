// 
//  CardVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CardVertex: Vertex {
    let nodeID: String
    let name: String
    let imageName: String?
    let priority: UInt
    var point: CGPoint
    var isHighlighted: Bool
}

extension CardVertex: Identifiable {
    
    var id: String {
        "\(nodeID)\(name)\(isHighlighted)"
    }
}

extension CardVertex {
    
    init(data: CardNode, point: CGPoint) {
        nodeID        = data.id
        name          = data.name
        imageName     = data.imageName
        priority      = data.priority
        isHighlighted = false
        
        self.point = point
    }
}

extension CardVertex: Decodable {
    
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
        
        isHighlighted = false
    }
}

extension CardVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeID)
    }
}

extension CardVertex: Equatable {
    
    static func ==(lhs: CardVertex, rhs: CardVertex) -> Bool {
        lhs.nodeID == rhs.nodeID
    }
}

#if DEBUG
extension CardVertex {
    
    static var placeholder: CardVertex {
        CardVertex(nodeID: "0", name: "SC", imageName: "sc", priority: 0, point: .zero, isHighlighted: false)
    }
}
#endif
