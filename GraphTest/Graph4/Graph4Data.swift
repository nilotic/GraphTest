// 
//  Graph4Data.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

final class Graph4Data: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var vertexes = [AccountVertex]()
    @Published var isGuideHidden = false
    @Published var priorityCounts: [UInt] = [0, 0, 0]
    
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
        var priorities: [UInt] {
            let totalCount = (1...8).randomElement() ?? 1
            
            let priority1Count = min(2, totalCount)
            let priority2Count = max(0, min(3, totalCount - priority1Count))
            let priority3Count = max(0, min(3, totalCount - priority1Count - priority2Count))
            return [UInt(priority1Count), UInt(priority2Count), UInt(priority3Count)]
        }
        
        // 1st. Set all available slots
        var vertexSlots = [VertexSlot]()
        for slot in 0..<8 {
            switch slot {
            case 0:     vertexSlots.append(contentsOf: [34, 35, 1, 2].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 1:     vertexSlots.append(contentsOf: [3, 4, 5, 6].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 2:     vertexSlots.append(contentsOf: [7, 8, 10, 11].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 3:     vertexSlots.append(contentsOf: [12, 13, 14, 15].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 4:     vertexSlots.append(contentsOf: [16, 17, 19, 20].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 5:     vertexSlots.append(contentsOf: [21, 22, 23, 24].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 6:     vertexSlots.append(contentsOf: [25, 26, 28, 29].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            case 7:     vertexSlots.append(contentsOf: [30, 31, 32, 33].map { VertexSlot(slot: UInt(slot), line: UInt($0))})
            default:    break
            }
        }
        
        // 2nd. Set vertexes
        var vertexes = [AccountVertex]()
        
        let priorityCounts = priorities
        let totalCount = priorityCounts.reduce(0) { $0 + $1 }
        
        switch totalCount {
        case 3:
            let emptySlot = [1, 5].randomElement() ?? 1
            switch emptySlot {
            case 1:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 1)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 16)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
            
            case 5:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 34)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 19)))
                
            default:
                break
            }
            
        
        case 4:
            vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 34)))
            vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
            vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 16)))
            vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
        
            
        case 5:
            // Priority 1
            let emptySlot = [1, 3, 5, 7].randomElement() ?? 1
            
            switch emptySlot {
            case 1:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 2)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 19)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 31)))
                
            case 3:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 16)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 30)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 35)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                
            case 5:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 20)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 30)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 35)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 13)))
                
            case 7:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 34)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 5)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 19)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
                
            default:
                break
            }
        
            
        case 6:
            // (Priority1, Priority2)
            let emptySlot = [(1, 6), (3, 6), (5, 2), (7, 2)].randomElement() ?? (1, 6)
            
            switch emptySlot {
            case (1, 6):
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 1)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 7)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 19)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 30)))
                
            case (3, 6):
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 35)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 11)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 17)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 23)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 29)))
            
            case (5, 2):
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 1)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 19)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 25)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 31)))
            
            case (7, 2):
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 35)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 5)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 17)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 23)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 29)))
                
            default:
                break
            }
            
            
        case 7:
            // Priority 1
            let emptySlot = [1, 3, 5, 7].randomElement() ?? 1
            
            switch emptySlot {
            case 1:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 2)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 7)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 17)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 22)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 27)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 32)))
                
            case 3:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 16)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 21)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 26)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 31)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 1)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 11)))
                
            case 5:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 20)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 25)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 30)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 35)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 5)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 10)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 14)))
                
            case 7:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 34)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 4)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 8)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 13)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 19)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 29)))
                
            default:
                break
            }
        
        
        case 8:
            let emptySlot = [1, 3, 5, 7].randomElement() ?? 1
            switch emptySlot {
            case 1:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 2)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 7)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 12)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 16)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 21)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 25)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 29)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 33)))
                
            case 3:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 16)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 21)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 25)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 29)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 33)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 2)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 6)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 11)))
                
            case 5:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 20)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 25)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 7, line: 30)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 34)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 3)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 7)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 11)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 15)))
                
            case 7:
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 0, line: 34)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 1, line: 3)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 7)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 2, line: 11)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 3, line: 15)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 4, line: 20)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 5, line: 24)))
                vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: VertexSlot(slot: 6, line: 29)))
                
            default:
                break
            }
          
            
        default:
            for (priority, count) in priorityCounts.enumerated() {
                switch priority {
                case 0:
                    var priority1Slots: [UInt] = [0, 4].shuffled()
                    
                    switch count {
                    case 1:
                        guard let priority1Slot = priority1Slots.popLast(), let slot = vertexSlots.filter({ $0.slot == priority1Slot }).shuffled().first else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot))
                        
                    case 2:
                        guard let slot1 = vertexSlots.filter({ $0.slot == 0 }).shuffled().first, let slot2 = vertexSlots.filter({ $0.slot == 4 }).shuffled().first else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1))
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot2))
                        
                    default:
                        continue
                    }
                    
                    // Remove slots
                    vertexSlots.removeAll(where: { priority1Slots.contains($0.slot) })
                    
                    // Remove unavailable slots
                    let priority1Lines: [UInt] = [1, 2, 16, 17, 19, 20, 34, 35]
                    
                    for vertex in vertexes {
                        guard priority1Lines.contains(vertex.slot.line) else { continue }
                        
                        for offset in [34, 35, 1, 2] {
                            let unavailableLine = (Int(vertex.slot.line) + offset) % 36
                            vertexSlots.removeAll(where: { $0.line == unavailableLine })
                        }
                    }
                    
                    
                case 1:
                    let priority2Slots: [UInt] = [1, 3, 5, 7].shuffled()
                    
                    switch count {
                    case 1...3:
                        for priority2Slot in Array(priority2Slots[0..<Int(count)]) {
                            let filtered = vertexSlots.filter { $0.slot == priority2Slot }
                            
                            guard let slot = (priority2Slot == 7 ? filtered.last : filtered.first) else { continue }
                            vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot))
                        }
                     
                    default:
                        continue
                    }
                    
                    // Remove slots
                    vertexSlots.removeAll(where: { priority2Slots.contains($0.slot) })
                    
                    // Remove unavailable slots
                    let priority2Lines: [UInt] = [3, 4, 5, 6, 12, 13, 14, 15, 21, 22, 23, 24, 30, 31, 32, 33]
                    
                    for vertex in vertexes {
                        guard priority2Lines.contains(vertex.slot.line) else { continue }
                        
                        for offset in [34, 35, 1, 2] {
                            let unavailableLine = (Int(vertex.slot.line) + offset) % 36
                            vertexSlots.removeAll(where: { $0.line == unavailableLine })
                        }
                    }
                    
                    
                case 2:
                    var priority2Slots: [UInt] = [2, 6].shuffled()
                    
                    switch count {
                    case 1:
                        guard let priority2Slot = priority2Slots.popLast(), let slot = vertexSlots.filter({ $0.slot == priority2Slot }).shuffled().first else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot))
                        
                    case 2:
                        guard let slot1 = vertexSlots.filter({ $0.slot == 2 }).shuffled().first, let slot2 = vertexSlots.filter({ $0.slot == 6 }).shuffled().first else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1))
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot2))
                        
                    case 3:
                        let slot2s = vertexSlots.filter { $0.slot == 2 }
                        let slot6s = vertexSlots.filter { $0.slot == 6 }
                        
                        var slots = [slot2s, slot6s]
                        
                        guard let affodableSlots = (slot2s.count < slot6s.count ? slots.popLast() : slots.removeFirst()), let placelessSlots = slots.popLast() else { continue }
                      
                        guard let slot1 = placelessSlots.shuffled().first else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1))

                        guard let first = affodableSlots.first, let last = affodableSlots.last else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: first))
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: last))
                        
                    default:
                        continue
                    }
                    
                default:
                    continue
                }
            }
        }
        
        
        DispatchQueue.main.async {
            self.vertexes       = vertexes
            self.priorityCounts = priorityCounts
        }
    }
}
