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
    @Published var isGuideHidden = false
    @Published var priorityCounts: [UInt] = [0, 0, 0]
    @Published var totalCount: UInt = 1
    @Published var isRandom = false
    
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
        var vertexPriorities: [UInt] {
            let totalCount = isRandom ? ((1...8).randomElement() ?? 1) : self.totalCount
            
            let priority1Count = min(2, totalCount)
            let priority2Count = max(0, min(3, totalCount - priority1Count))
            let priority3Count = max(0, min(3, totalCount - priority1Count - priority2Count))
            
            var priorities = [UInt]()
            for _ in 0..<priority1Count {
                priorities.append(0)
            }
            
            for _ in 0..<priority2Count {
                priorities.append(1)
            }
            
            for _ in 0..<priority3Count {
                priorities.append(2)
            }
            
            return priorities.shuffled()
        }
        
        // 1st. Set all available slots
        var vertexSlots = [VertexSlot2]()
        let slots: [UInt] = [0, 1, 2, 3, 4, 5, 6, 7]
        
        for slot in slots {
            var section: [VertexSlot2] {
                switch slot {
                case 0:
                    return [34, 35, 1, 2].reduce([VertexSlot2]()) {
                        $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: 1, line: UInt($1))]
                    }
                        
                case 1:
                    return [3, 4, 5, 6].reduce([VertexSlot2]()) {
                        let orbit = UInt($1 == 6 ? 2 : 1)
                        return $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: orbit, line: UInt($1))]
                    }
                        
                case 2:
                    return [7, 8, 10, 11].reduce([VertexSlot2]()) {
                        $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: 2, line: UInt($1))]
                    }
                    
                case 3:
                    return [12, 13, 14, 15].reduce([VertexSlot2]()) {
                        let orbit = UInt($1 == 12 ? 2 : 1)
                        return $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: orbit, line: UInt($1))]
                    }
                    
                case 4:
                    return [16, 17, 19, 20].reduce([VertexSlot2]()) {
                        $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: 1, line: UInt($1))]
                    }
                    
                case 5:
                    return [21, 22, 23, 24].reduce([VertexSlot2]()) {
                        let orbit =  UInt($1 == 24 ? 2 : 1)
                        return $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: orbit, line: UInt($1))]
                    }
                    
                case 6:
                    return [25, 26, 28, 29].reduce([VertexSlot2]()) {
                        $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: 2, line: UInt($1))]
                    }
                    
                case 7:
                    return [30, 31, 32, 33].reduce([VertexSlot2]()) {
                        let orbit = UInt($1 == 30 ? 2 : 1)
                        return $0 + [VertexSlot2(id: slot, orbit: 0, line: UInt($1)), VertexSlot2(id: slot, orbit: orbit, line: UInt($1))]
                    }
                    
                default:
                    return []
                }
            }
            
            vertexSlots.append(contentsOf: section)
        }
        
        vertexSlots.shuffle()
            
        
        // 2nd. Set vertexes
        let lines: [UInt] = [1,  2,  3,  4,  5,  6,  7,  8,
                             10, 11, 12, 13, 14, 15, 16, 17,
                             19, 20, 21, 22, 23, 24, 25, 26,
                             28, 29, 30, 31, 32, 33, 34, 35]
        
        var line: UInt = lines.randomElement() ?? 1
        
        var vertexes = [AccountVertex2]()
        var priorityCounts: [UInt] = [0, 0, 0]
        let priorities = vertexPriorities
        
        for priority in priorities {
            switch priority {
            case 0:
                guard let slot = vertexSlots.filter({ $0.line == line && $0.orbit == 0 }).shuffled().first else {
                    log(.error, "Failed to get a slot.")
                    continue
                }
                
                vertexes.append(AccountVertex2(id: id, name: name, imageName: imageName, priority: UInt(priority), slot: slot))
                
                let offset = UInt((priorityCounts[0] == 0 ? 5 : 4) + (8 - priorities.count))
                line = (line + offset) % 36
                
                priorityCounts[0] += 1
                                    
            case 1:
                guard let slot = vertexSlots.filter({ $0.line == line && $0.orbit == 0 }).shuffled().first else {
                    log(.error, "Failed to get a slot.")
                    continue
                }
                
                vertexes.append(AccountVertex2(id: id, name: name, imageName: imageName, priority: UInt(priority), slot: slot))
                
                let offset = UInt(12 - priorities.count)
                line = (line + offset) % 36
            
                priorityCounts[1] += 1
                
            case 2:
                guard let slot = vertexSlots.filter({ $0.line == line && ($0.orbit == 1 || $0.orbit == 2) }).shuffled().first else {
                    log(.error, "Failed to get a slot.")
                    continue
                }
                
                vertexes.append(AccountVertex2(id: id, name: name, imageName: imageName, priority: UInt(priority), slot: slot))
                
                let offset = UInt(12 - priorities.count)
                line = (line + offset) % 36
                
                priorityCounts[2] += 1

            default:
                continue
            }
            
            line = line % 9 == 0 ? line + 1 : line
        }
        
        DispatchQueue.main.async {
            self.totalCount     = priorityCounts.reduce(0) { $0 + $1 }
            self.vertexes       = vertexes
            self.priorityCounts = priorityCounts
        }
    }
}
