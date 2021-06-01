// 
//  CoworkerVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct CoworkerVertex: Vertex, Identifiable {
    let id: String
    let name: String
    let imageName: String?
    let priority: UInt
    let point: CGPoint
}

extension CoworkerVertex {
    
    init(data: CoworkerNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension CoworkerVertex: Decodable {
    
    private enum Key: String, CodingKey {
        case id
        case name
        case imageName
        case priority
        case point
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        do { id        = try container.decode(String.self,  forKey: .id) }        catch { throw error }
        do { name      = try container.decode(String.self,  forKey: .name) }      catch { throw error }
        do { imageName = try container.decode(String.self,  forKey: .imageName) } catch { throw error }
        do { priority  = try container.decode(UInt.self,    forKey: .priority) }  catch { throw error }
        do { point     = try container.decode(CGPoint.self, forKey: .point) }     catch { throw error }
    }
}

extension CoworkerVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CoworkerVertex: Equatable {
    
    static func ==(lhs: CoworkerVertex, rhs: CoworkerVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension CoworkerVertex {
    
    static var placeholder: CoworkerVertex {
        CoworkerVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
