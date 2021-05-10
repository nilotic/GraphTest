// 
//  UserVertexView.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct UserVertexView: View {
    
    // MARK: - Value
    // MARK: Public
    let data: User
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1)), lineWidth: 2)
                .background(Circle().foregroundColor(Color.black))
                .frame(width: 120, height: 120)
                .padding()
            
            Group {
                Image(data.imageName)
                    .resizable()
                    .frame(width: 98, height: 98)
                    .padding(.bottom, 20)
                
                Text(data.name)
                    .font(.system(size: 12, weight: .bold))
                    .padding(.top, 70)
            }
            .clipped()
        }
    }
}

#if DEBUG
struct UserVertexView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = UserVertexView(data: .placeholder)
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif
