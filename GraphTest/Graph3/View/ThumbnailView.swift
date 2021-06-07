// 
//  ThumbnailView.swift
//
//  Created by Den Jo on 2021/06/07.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct ThumbnailView: View {
    
    // MARK: - Value
    // MARK: Private
    private var data: UserVertex
    private let action: (() -> Void)?
    @State private var index: Int
    
    
    // MARK: - Initializer
    init(data: UserVertex, index: Int, action: (() -> Void)? = nil) {
        self.data   = data
        self.index  = index
        self.action = action
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        Button(action: { action?() }) {
            ZStack {
                Circle()
                    .stroke(Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)), lineWidth: 2)
                    .background(Circle().foregroundColor(Color.black))
                    .frame(width: 40, height: 40)
                
                if let imageName = data.imageName {
                    Image(imageName)
                        .resizable()
                        .frame(width: 27, height: 27)
                }
            }
        }
        .buttonStyle(ThumbnailButtonStyle(index: index))
        .opacity(index == 1 ? 0 : 1)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                index = 0
            }
        }
    }
}

#if DEBUG
struct ThumbnailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = ThumbnailView(data: .placeholder, index: 0)
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
