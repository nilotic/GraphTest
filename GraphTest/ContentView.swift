//
//  ContentView.swift
//  GraphTest
//
//  Created by Den Jo on 2021/05/04.
//

import SwiftUI
import SceneKit

struct ContentView: View {

    var body: some View {
        GraphView()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = ContentView()
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.light)
            
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
