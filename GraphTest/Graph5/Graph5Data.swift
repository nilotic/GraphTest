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
    @Published var vertexes = [AccountVertex2]()
    
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
        var vertexes = [AccountVertex2]()
        
        for i in 0..<8 {
            let priority = UInt((0...2).randomElement() ?? 2)
            
            var offset: Int {
                switch i {
                case 1...8:
                    switch vertexes[i - 1].slot.priority {
                    case 3:     return 2
                    default:    return priority == 3 ? 2 : ((1...3).randomElement() ?? 1)
                    }
                    
                default:
                    return (0...2).randomElement() ?? 0
                }
            }
            
            vertexes.append(AccountVertex2(id: id, name: name, imageName: imageName, slot: VertexSlot2(slot: UInt(i), offset: offset, priority: priority)))
        }
        
        DispatchQueue.main.async { self.vertexes = vertexes }
    }
}
