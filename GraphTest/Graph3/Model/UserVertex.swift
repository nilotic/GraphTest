// 
//  UserVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct UserVertex: Vertex {
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

extension UserVertex: Identifiable {
    
    var id: String {
        "\(nodeID)\(name)\(isHighlighted)"
    }
}

extension UserVertex {
    
    init(data: UserNode, point: CGPoint) {
        nodeID    = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension UserVertex: Decodable {
    
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

extension UserVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nodeID)
    }
}

extension UserVertex: Equatable {
    
    static func ==(lhs: UserVertex, rhs: UserVertex) -> Bool {
        lhs.nodeID == rhs.nodeID
    }
}


#if DEBUG
extension UserVertex {
    
    static var placeholder: UserVertex {
        UserVertex(nodeID: "0", name: "Oliver", imageName: "memoji1")
    }
}
#endif
