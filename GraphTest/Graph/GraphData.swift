//
//  GraphData.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SwiftUI
import Combine

final class GraphData {
    
    // MARK: - Value
    // MARK: Public
    var verticies = [Vertex]()
    var edges     = [Edge]()
    
//    var vertex: Vertex {
//        return Vertex(name: name, degree: 1, image: profileImage)
//    }
    
    
    // MARK: Private
    private var profileImage: UIImage {
        [#imageLiteral(resourceName: "memoji1"),#imageLiteral(resourceName: "memoji2"),#imageLiteral(resourceName: "memoji3"),#imageLiteral(resourceName: "memoji4"),#imageLiteral(resourceName: "memoji5"),#imageLiteral(resourceName: "memoji6"),#imageLiteral(resourceName: "memoji7"),#imageLiteral(resourceName: "memoji8"),#imageLiteral(resourceName: "memoji9"),#imageLiteral(resourceName: "memoji10"),#imageLiteral(resourceName: "memoji11"),#imageLiteral(resourceName: "memoji12"),#imageLiteral(resourceName: "memoji13"),#imageLiteral(resourceName: "memoji14"),#imageLiteral(resourceName: "memoji15"),#imageLiteral(resourceName: "memoji16"),#imageLiteral(resourceName: "memoji17"),#imageLiteral(resourceName: "memoji18"),#imageLiteral(resourceName: "memoji19"),#imageLiteral(resourceName: "memoji20"),#imageLiteral(resourceName: "memoji21"),#imageLiteral(resourceName: "memoji22"),#imageLiteral(resourceName: "memoji23"),#imageLiteral(resourceName: "memoji24"),#imageLiteral(resourceName: "memoji25"),#imageLiteral(resourceName: "memoji26")].randomElement() ?? #imageLiteral(resourceName: "memoji1")
    }
    
    private var name: String {
        ["Oliver", "Jake", "Noah", "James", "Jack", "Connor", "Liam", "John", "Harry", "Callum",
         "Mason", "Robert", "Jacob", "Jacob", "Jacob", "Michael", "Charlie", "Kyle", "William", "William",
         "Amelia", "Margaret", "Emma", "Mary", "Olivia", "Samantha", "Olivia", "Patricia", "Isla", "Bethany",
         "Sophia", "Jennifer", "Emily", "Elizabeth", "Isabella", "Elizabeth", "Poppy", "Joanne", "Ava", "Linda"].randomElement() ?? "Oliver"
    }
}
