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
        var priorityCounts: [UInt] {
            let totalCount = 8
        
            let priority1Count = (1...4).randomElement() ?? 1
            let priority2Count = (1...(totalCount - priority1Count)).randomElement() ?? 1
            
            let remainder = totalCount - (priority1Count + priority2Count)
            let priority3Count = (0...remainder).randomElement() ?? 0
            
            log(.info, [UInt(priority1Count), UInt(priority2Count), UInt(priority3Count)])
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
                    
                case 3:
                    guard let priority1Slot1 = priority1Slots.popLast(), let slot1 = vertexSlots.filter({ $0.slot == priority1Slot1 }).shuffled().first else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1))

                    guard let priority1Slot2 = priority1Slots.popLast() else { continue }
                    let slots = (vertexSlots.filter { $0.slot == priority1Slot2 })
                    
                    guard let first = slots.first, let last = slots.last else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: first))
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: last))
                    
                case 4:
                    var slots = (vertexSlots.filter { $0.slot == 0 })
                    
                    guard let slot1First = slots.first, let slot1Last = slots.last else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1First))
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1Last))
                    
                    slots = (vertexSlots.filter { $0.slot == 4 })
                    guard let slot2First = slots.first, let slot2Last = slots.last else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot2First))
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot2Last))
                    
                default:
                    continue
                }
                
                // Remove slots
                vertexSlots.removeAll(where: { priority1Slots.contains($0.slot) })
                
                // Remove unavailable slots
                for vertex in vertexes {
                    if (vertex.slot.line == 1 || vertex.slot.line == 2) {
                        let line = [5, 6].randomElement() ?? 5
                        vertexSlots.removeAll(where: { $0.line == 3  || $0.line == 4 || $0.line == line })
                    }
                    
                    if (vertex.slot.line == 16 || vertex.slot.line == 17) {
                        let line = [12, 13].randomElement() ?? 12
                        vertexSlots.removeAll(where: { $0.line == 14 || $0.line == 15 || $0.line == line })
                    }
                    
                    if (vertex.slot.line == 19 || vertex.slot.line == 20) {
                        let line = [23, 24].randomElement() ?? 23
                        vertexSlots.removeAll(where: { $0.line == 21 || $0.line == 22 || $0.line == line })
                    }
                    
                    if (vertex.slot.line == 34 || vertex.slot.line == 35) {
                        let line = [30, 31].randomElement() ?? 30
                        vertexSlots.removeAll(where: { $0.line == 32 || $0.line == 33 || $0.line == line})
                    }
                }
                
                
            case 1:
                let priority2Slots: [UInt] = [1, 3, 5, 7].shuffled()
                
                switch count {
                case 1...4:
                    for priority2Slot in Array(priority2Slots[0..<Int(count)]) {
                        guard let slot = vertexSlots.filter({ $0.slot == priority2Slot }).shuffled().first else { continue }
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot))
                    }
                    
                case 5...8:
                    var filteredSlots = vertexSlots.filter({ priority2Slots.contains($0.slot) })
                    var availableSlots = [VertexSlot]()
                    
                    // distribute equally
                    for slot in priority2Slots {
                        guard let index = filteredSlots.firstIndex(where: { $0.slot == slot }) else { continue }
                        availableSlots.append(filteredSlots[index])
                        filteredSlots.remove(at: index)
                    }
                    
                    for slot in priority2Slots {
                        guard let index = filteredSlots.lastIndex(where: { $0.slot == slot }) else { continue }
                        availableSlots.append(filteredSlots[index])
                        filteredSlots.remove(at: index)
                    }
                    
                    for i in 0..<count {
                        guard let slot = availableSlots.popLast() else {
                            log(.error, "Failed to get a slot. total slots: \(filteredSlots.count) | index: \(i)")
                            continue
                        }
                            
                        vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot))
                    }
                    
                default:
                    continue
                }
                
                // Remove slots
                vertexSlots.removeAll(where: { priority2Slots.contains($0.slot) })
                
                // Remove unavailable slots
                for vertex in vertexes {
                    if vertex.slot.line == 6    { vertexSlots.removeAll(where: { $0.line == 7 }) }
                    if vertex.slot.line == 12   { vertexSlots.removeAll(where: { $0.line == 11 }) }
                    if vertex.slot.line == 24   { vertexSlots.removeAll(where: { $0.line == 25 }) }
                    if vertex.slot.line == 30   { vertexSlots.removeAll(where: { $0.line == 29 }) }
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
                    guard let priority2Slot1 = priority2Slots.popLast(), let slot1 = vertexSlots.filter({ $0.slot == priority2Slot1 }).shuffled().first else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1))

                    guard let priority2Slot2 = priority2Slots.popLast() else { continue }
                    let slots = (vertexSlots.filter { $0.slot == priority2Slot2 })
                    
                    guard let first = slots.first, let last = slots.last else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: first))
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: last))
                    
                case 4:
                    var slots = vertexSlots.filter({ $0.slot == 2 })
                    
                    // Divide equally
                    if slots.count == 4, let first = Array(slots[0...1]).shuffled().first, let last = Array(slots[2...3]).shuffled().last {
                        slots = [first, last]
                    }
                    
                    guard let slot1First = slots.first, let slot1Last = slots.last else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1First))
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot1Last))
                    
                    slots = vertexSlots.filter({ $0.slot == 6 })
                    if slots.count == 4, let first = Array(slots[0...1]).shuffled().first, let last = Array(slots[2...3]).shuffled().last {
                        slots = [first, last]
                    }
                    
                    guard let slot2First = slots.first, let slot2Last = slots.last else { continue }
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot2First))
                    vertexes.append(AccountVertex(id: id, name: name, imageName: imageName, slot: slot2Last))
                    
                default:
                    continue
                }
                
            default:
                continue
            }
        }
        
        DispatchQueue.main.async { self.vertexes = vertexes }
    }
}
