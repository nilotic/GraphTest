// 
//  Graph5Data.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

final class Graph5Data: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var vertexes = [AccountVertex]()
    
    // MARK: Private
    private var id: String {
        "\((0...100000).randomElement() ?? 0)"
    }
    
    private var name: String {
        ["Oliver", "Jake", "Noah", "James", "Jack", "Connor", "Liam", "John", "Harry", "Callum",
         "Mason", "Robert", "Jacob", "Jacob", "Jacob", "Michael", "Charlie", "Kyle", "William", "William",
         "Amelia", "Margaret", "Emma", "Mary", "Olivia", "Samantha", "Olivia", "Patricia", "Isla", "Bethany",
         "Sophia", "Jennifer", "Emily", "Elizabeth", "Isabella", "Elizabeth", "Poppy", "Joanne", "Ava", "Linda"].randomElement() ?? "Oliver"
    }
    
    private var imageName: String {
        ["memoji1", "memoji2", "memoji3", "memoji4", "memoji5", "memoji6", "memoji7", "memoji8", "memoji9",
         "memoji10", "memoji11", "memoji12", "memoji13", "memoji14", "memoji15", "memoji16", "memoji17", "memoji18", "memoji19",
         "memoji20", "memoji21", "memoji22", "memoji23", "memoji24", "memoji25", "memoji26", "memoji27"].randomElement() ?? "momoji1"
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        let offset = (0...3).randomElement() ?? 0
        
        var vertexes = [AccountVertex]()
        for i in 0..<8 {
            vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: UInt(i), offset: offset)))
        }
        
        DispatchQueue.main.async { self.vertexes = vertexes }
    }
}
