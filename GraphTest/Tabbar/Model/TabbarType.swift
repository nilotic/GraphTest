// 
//  TabbarType.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import UIKit
import SwiftUI

enum TabbarType {
    case graph1
    case graph2
    case graph3
}

extension TabbarType {
    
    var title: LocalizedStringKey {
        switch self {
        case .graph1:    return "Graph1"
        case .graph2:    return "Graph2"
        case .graph3:    return "Graph3"
        }
    }
    
    var iconName: String {
        switch self {
        case .graph1:    return "1.circle"
        case .graph2:    return "2.circle"
        case .graph3:    return "3.circle"
        }
    }
    
    var rawValue: Int {
        switch self {
        case .graph1:    return 0
        case .graph2:    return 1
        case .graph3:    return 2
        }
    }
}

extension TabbarType: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension TabbarType: Equatable {
    
    static func ==(lhs: TabbarType, rhs: TabbarType) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

