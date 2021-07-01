// 
//  Graph5View.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Graph5View: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = Graph5Data()
    
    private let lineColor = { (index: Int) -> Color in
        switch index {
        case 9, 18, 27, 36:     return .clear
        case 11, 7:             return Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        case 15, 21:            return Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        default:                return Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        }
    }
    
    private let lineWidth = { (index: Int) -> CGFloat in
        switch index {
        case 11, 7:         return 3
        case 15, 21:        return 3
        default:            return 1
        }
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                countView
                
                Group{
                    if !data.isGuideHidden {
                        guideLine
                    }
                    
                    vertexView
                    userVertextView
                }
                .offset(y: 20)
                
                guideButton
                    .offset(x: 64 - proxy.size.width / 2 , y: proxy.size.height / 2 - 110)
                
                changeButton
                    .offset(x: proxy.size.width / 2 - 48 , y: proxy.size.height / 2 - 110)
            }
            .onAppear {
                data.request()
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: Private
    private var countView: some View {
        VStack(alignment: .center, spacing: 40) {
            HStack(alignment: .bottom, spacing: 20) {
                VStack {
                    AccountVertexView2(data: AccountVertex2(id: "0", name: "Oliver", imageName: "memoji1", priority: 0, slot: .placeholder))
                    Text("\(data.priorityCounts[0])")
                }
                
                VStack {
                    AccountVertexView2(data: AccountVertex2(id: "1", name: "Jake", imageName: "memoji2", priority: 1, slot: .placeholder))
                        .offset(y: -8)
                    
                    Text("\(data.priorityCounts[1])")
                }
                
                VStack {
                    AccountVertexView2(data: AccountVertex2(id: "2", name: "Noah", imageName: "memoji3", priority: 2, slot: .placeholder))
                        .offset(y: -12)
                    
                    Text("\(data.priorityCounts[2])")
                }
                
                VStack(alignment: .center) {
                    Text("Total: \(data.totalCount)")
                        .padding(.leading, 20)
                    
                    Stepper("", value: $data.totalCount, in: 1...8, step: 1)
                        .frame(width: 120)
                }
                .frame(width: 120, alignment: .center)
            }
            
            // Toggle
            VStack(alignment: .trailing) {
                Text("Random")
                Toggle("", isOn: $data.isRandom)
            }
            .padding(.trailing, 50)
        }
        .offset(y: -280)
    }
    
    private var guideLine: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Purple Top, Bottom
                ArcShape(startAngle: .degrees(240), endAngle: .degrees(300))
                    .stroke(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), lineWidth: 5)
                    .frame(width: 360, height: 360)
  
                ArcShape(startAngle: .degrees(60), endAngle: .degrees(120))
                    .stroke(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), lineWidth: 5)
                    .frame(width: 360, height: 360)
  

                // Purple Left, Right
                ArcShape(startAngle: .degrees(130), endAngle: .degrees(230))
                    .stroke(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), lineWidth: 5)
                    .frame(width: 320, height: 320)
  
                ArcShape(startAngle: .degrees(310), endAngle: .degrees(50))
                    .stroke(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), lineWidth: 5)
                    .frame(width: 320, height: 320)
                
                
                // Green
                ArcShape(startAngle: .degrees(0), endAngle: .degrees(360))
                    .stroke(Color(#colorLiteral(red: 0.09860403091, green: 0.6555238366, blue: 0.5823600888, alpha: 1)), lineWidth: 5)
                    .frame(width: 280, height: 280)
                
                
                // Orbit
                ForEach(7..<10) { i in
                    Path {
                        $0.addArc(center: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2), radius: CGFloat(i) * 20,
                                  startAngle: .radians(0), endAngle: .radians(2 * .pi), clockwise: true)
                    }
                    .stroke(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), lineWidth: 1)
                }
                
                
                // Degree
                ForEach(1..<36) {
                    Path {
                        $0.move(to: CGPoint(x: proxy.size.width / 2 - 180, y: proxy.size.height / 2))
                        $0.addLine(to: CGPoint(x: proxy.size.width / 2 + 180, y: proxy.size.height / 2))
                    }
                    .stroke(($0 % 9 == 0) ? Color.clear : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                    .rotationEffect(.radians(.pi / 18 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(0.5)
        }
    }
    
    private var vertexView: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(data.vertexes) { vertex in
                    // Path
                    Path { path in
                        path.move(to: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2))
                        path.addLine(to: CGPoint(x: vertex.slot.point.x + proxy.size.width / 2, y: vertex.slot.point.y + proxy.size.height / 2))
                    }
                    .stroke(Color.white, lineWidth: 1.5)
                    
                    // Vertex
                    AccountVertexView2(data: vertex)
                        .offset(x: vertex.slot.point.x, y: vertex.slot.point.y)
                }
            }
        }
    }
    
    private var userVertextView: some View {
        ZStack {
            Circle()
                .stroke(Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), lineWidth: 1)
                .background(Circle().foregroundColor(Color.black))
                .frame(width: 112, height: 112)
                
            VStack(spacing: 0) {
                Image("memoji27")
                    .resizable()
                    .frame(width: 70, height: 70)
                    
                Text("\(Int(112))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
            }
            .clipped()
        }
        .zIndex(1)
    }
    
    private var guideButton: some View {
        Button(action: { data.isGuideHidden.toggle() }) {
            ZStack {
                // Background
                Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1))
                
                // Image
                Image(systemName: data.isGuideHidden ? "squareshape.squareshape.dashed" : "squareshape.dashed.squareshape")
                    .scaleEffect(1.5)
                    .foregroundColor(.white)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(24)
        }
        .buttonStyle(ButtonStyle1())
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
    }
    
    private var changeButton: some View {
        Button(action: { data.request() }) {
            ZStack {
                // Background
                Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1))
                
                // Image
                Image(systemName: "arrow.triangle.2.circlepath.circle")
                    .scaleEffect(1.5)
                    .foregroundColor(.white)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(24)
        }
        .buttonStyle(ButtonStyle1())
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
    }
}

#if DEBUG
struct Graph5View_Previews: PreviewProvider {
    
    // https://www.ios-resolution.com
    static var previews: some View {
        let view = Graph5View()
        
        Group {
            view
                .previewDevice("iPhone 8")
                .previewDisplayName("iPhone 8      ( 375 x 667  |   4.7 inch )")
            /*
            view
                .previewDevice("iPhone 8 Plus")
                .previewDisplayName("iPhone 8 Plus      ( 414 x 736  |   5.5 inch )")
            
            view
                .previewDevice("iPhone X")
                .previewDisplayName("iPhone X     ( 375 x 812  |   5.85 inch )")
            
            view
                .previewDevice("iPhone 11")
                .previewDisplayName("iPhone 11     ( 414 x 896  |   6.1 inch )")
            
            view
                .previewDevice("iPhone 11 Pro")
                .previewDisplayName("iPhone 11 Pro    ( 375 x 812  |   5.85 inch )")
            
            view
                .previewDevice("iPhone 12 mini")
                .previewDisplayName("iPhone 12 mini     ( 375 x 812  |   5.42 inch )")
                
            view
                .previewDevice("iPhone 12")
                .previewDisplayName("iPhone 12      ( 390 x 844  |   6.06 inch )")
            
            view
                .previewDevice("iPhone 12 Pro Max")
                .previewDisplayName("iPhone 12 Pro Max     ( 428 x 926  |   6.68 inch )")*/
        }
        .preferredColorScheme(.dark)
    }
}
#endif
