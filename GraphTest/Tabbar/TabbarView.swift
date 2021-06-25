// 
//  TabbarView.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct TabbarView: View {
   
    // MARK: - Value
    // MARK: Private
    @State private var selection: TabbarType = .graph1
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        TabView(selection: $selection) {
            Graph1View()
                .tabItem {
                    TabbarItem(type: .graph1, selection: $selection)
                }
                .tag(TabbarType.graph1)
            
            Graph2View()
                .tabItem {
                    TabbarItem(type: .graph2, selection: $selection)
                }
                .tag(TabbarType.graph2)
            
            Graph3View()
                .tabItem {
                    TabbarItem(type: .graph3, selection: $selection)
                }
                .tag(TabbarType.graph3)
            
            
            Graph4View()
                .tabItem {
                    TabbarItem(type: .graph4, selection: $selection)
                }
                .tag(TabbarType.graph4)
        }
    }
}

#if DEBUG
struct TabbarView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = TabbarView()
        
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
