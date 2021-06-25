// 
//  Graph4View.swift
//
//  Created by Den Jo on 2021/06/25.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

struct Graph4View: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = Graph4Data()
    
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
                guideLine
                vertexView
                
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
    private var guideLine1: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                ArcShape(startAngle: .degrees(240), endAngle: .degrees(300))
                    .fill(Color(#colorLiteral(red: 0.5333333333, green: 0.5, blue: 0.9686274529, alpha: 0.7)))
                    .frame(width: 360, height: 360)
  
                ArcShape(startAngle: .degrees(60), endAngle: .degrees(120))
                    .fill(Color(#colorLiteral(red: 0.5333333333, green: 0.5, blue: 0.9686274529, alpha: 0.7)))
                    .frame(width: 360, height: 360)
                
                
                // Orbit
                ForEach(6..<10) { i in
                    Path {
                        $0.addArc(center: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2), radius: CGFloat(i) * 20,
                                  startAngle: .radians(0), endAngle: .radians(2 * .pi), clockwise: true)
                    }
                    .stroke(i == 6 ? Color(#colorLiteral(red: 0.09860403091, green: 0.6555238366, blue: 0.5823600888, alpha: 1)) : (i == 9 ? Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)) : Color(#colorLiteral(red: 0.4893481731, green: 0.2662789822, blue: 0.9991762042, alpha: 1))), lineWidth: i == 9 ? 1 : 3)
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
    
    private var guideLine: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Yellow
                ArcShape(startAngle: .degrees(250), endAngle: .degrees(290))
                    .fill(Color(#colorLiteral(red: 1, green: 0.8724767566, blue: 0.3582777977, alpha: 1)))
                    .frame(width: 360, height: 360)
  
                ArcShape(startAngle: .degrees(70), endAngle: .degrees(110))
                    .fill(Color(#colorLiteral(red: 1, green: 0.8724767566, blue: 0.3582777977, alpha: 1)))
                    .frame(width: 360, height: 360)
                
                
                // Blue
                ArcShape(startAngle: .degrees(290), endAngle: .degrees(330))
                    .fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 320, height: 320)
  
                ArcShape(startAngle: .degrees(30), endAngle: .degrees(70))
                    .fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 320, height: 320)
                
                ArcShape(startAngle: .degrees(110), endAngle: .degrees(150))
                    .fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 320, height: 320)
  
                ArcShape(startAngle: .degrees(210), endAngle: .degrees(250))
                    .fill(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 320, height: 320)
                
                
                // Purple
                ArcShape(startAngle: .degrees(330), endAngle: .degrees(30))
                    .fill(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 280, height: 280)
  
                ArcShape(startAngle: .degrees(150), endAngle: .degrees(210))
                    .fill(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    .frame(width: 280, height: 280)
                
                
                
                // Orbit
                ForEach(7..<10) { i in
                    Path {
                        $0.addArc(center: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2), radius: CGFloat(i) * 20,
                                  startAngle: .radians(0), endAngle: .radians(2 * .pi), clockwise: true)
                    }
                    .stroke(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)), lineWidth: 2)
                }
                        
                
                // Degree
                ForEach(1..<36) {
                    Path {
                        $0.move(to: CGPoint(x: proxy.size.width / 2 - 180, y: proxy.size.height / 2))
                        $0.addLine(to: CGPoint(x: proxy.size.width / 2 + 180, y: proxy.size.height / 2))
                    }
                    .stroke(lineColor($0), lineWidth: lineWidth($0))
                    .rotationEffect(.radians(.pi / 18 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(0.5)
        }
    }
    
    private var vertexView: some View {
        ZStack {
            ForEach(data.vertexes) {
                AccountVertexView(data: $0)
                    .offset(x: $0.slot.point.x, y: $0.slot.point.y)
            }
        }
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
struct Graph4View_Previews: PreviewProvider {
    
    // https://www.ios-resolution.com
    static var previews: some View {
        let view = Graph4View()
        
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
