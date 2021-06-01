// 
//  InsuranceVertex.swift
//
//  Created by Den Jo on 2021/05/11.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct InsuranceVertex: Vertex, Identifiable {
    let id: String
    let name: String
    let imageName: String?
    let priority: UInt
    let point: CGPoint
}

extension InsuranceVertex {
    
    init(data: InsuranceNode, point: CGPoint) {
        id        = data.id
        name      = data.name
        imageName = data.imageName
        priority  = data.priority
        
        self.point = point
    }
}

extension InsuranceVertex: Decodable {
    
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

extension InsuranceVertex: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension InsuranceVertex: Equatable {
    
    static func ==(lhs: InsuranceVertex, rhs: InsuranceVertex) -> Bool {
        lhs.id == rhs.id
    }
}

#if DEBUG
extension InsuranceVertex {
    
    static var placeholder: InsuranceVertex {
        InsuranceVertex(id: "0", name: "SC", imageName: "sc", priority: 0, point: .zero)
    }
}
#endif
