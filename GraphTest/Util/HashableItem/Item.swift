//
//  Item.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//


import Foundation

struct Item: Identifiable {
    let id: Int
    var data: Any
}

extension Item {
        
    init<T: Hashable>(data: T) {
        id = data.hashValue
        self.data = data
    }
}

extension Item: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Item: Equatable {
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
