// 
//  FramePreferenceKey.swift
//
//  Created by Den Jo on 2021/04/12.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
  
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
