// 
//  Graph3View.swift
//
//  Created by Den Jo on 2021/05/10.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct Graph3View: View {
    
    // MARK: - Value
    // MARK: Private
    @StateObject private var data = Graph3Data()
    private let buttonStyle = ButtonStyle1()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                guideLine
                // curveGuideLine
                
                thumbnails
                    .offset(x: 0, y: 30 - proxy.size.height / 2)
                
                if !data.isGraphHidden {
                    graph
                }
                
                cardsView
                
                editButton
                    .offset(x: proxy.size.width / 2 - 48 , y: proxy.size.height / 2 - 48)
                
                dismissButton
                    .offset(x: 64 - proxy.size.width / 2 , y: proxy.size.height / 2 - 48)
            }
            .id(data.orientation.rawValue)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) {
                data.update(noitfication: $0, size: proxy.size)
            }
            .onAppear {
                data.request(size: proxy.size)
                data.update(isAnimated: true)
            }
        }
    }
    
    // MARK: Private
    private var guideLine: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Bound
                Color(.clear)
                    .border(Color.gray, width: 1)
                    .frame(width: min(proxy.size.width, proxy.size.height), height: min(proxy.size.width, proxy.size.height))
                
                
                // Orbit
                ForEach(1..<20) { i in
                    Path {
                        $0.addArc(center: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2), radius: CGFloat(i) * 40,
                                  startAngle: .radians(0), endAngle: .radians(2 * .pi), clockwise: true)
                    }
                    .stroke(Color.blue, lineWidth: 1)
                }
                        
                
                // Degree
                ForEach(1..<24) {
                    Path {
                        $0.move(to: CGPoint(x: proxy.size.width / 2, y: 0))
                        $0.addLine(to: CGPoint(x: proxy.size.width / 2, y: max(proxy.size.width, proxy.size.height) * 2))
                    }
                    .stroke(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
                    .rotationEffect(.radians(.pi / 12 * Double($0)))
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(0.5)
        }
    }
    
    private var curveGuideLine: some View {
        GeometryReader { proxy in
            ZStack {
                // Curve Box
                ForEach(0..<data.curveCount) {
                    ZStack {
                        Rectangle()
                            .frame(width: data.curveSize.width, height: data.curveSize.height)
                            .border(Color.red)
                            .offset(x: data.curveSize.width / 2, y: -data.curveSize.height / 2)
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .offset(x: data.curveSize.width / 2, y: -data.curveSize.height)
                    }
                    .rotationEffect(.radians(.pi / 6 * Double($0)))
                }
                
                // Control Point
                ForEach(0..<data.curveCount) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 5, height: 5)
                        .offset(x: ((data.curveSize.width / 2 + 12) * cos(data.controlPointAngle + data.curveUnit * CGFloat($0))), y: (data.curveSize.width / 2 + 12) * sin(data.controlPointAngle + data.curveUnit * CGFloat($0)))
                }
                
                // Curve
                ForEach(0..<data.curveCount) {
                    EdgeShape(source: CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2),
                              target: CGPoint(x: proxy.size.width / 2 + data.curveSize.width * cos(data.curveUnit * CGFloat($0)), y: proxy.size.height / 2 + data.curveSize.width * sin(data.curveUnit * CGFloat($0))),
                              size: data.curveSize,
                              ratio: data.curveRatio)
                        .stroke(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), lineWidth: 3)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .opacity(0.5)
        }
    }
    
    private var graph: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                // Edge
                ForEach(Array(data.edges.enumerated()), id: \.element) { (i, edge) in
                    EdgeShape(edge: edge, size: data.curveSize, ratio: data.curveRatio)
                        .trim(from: 0, to: data.isLineAnimated ? 1 : 0)
                        .stroke(Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), lineWidth: 3)
                        .animation(data.edgeAnimation(index: i))
                }
                .rotationEffect(.radians(Double(-data.angle)))
                
                
                // Vertex
                ForEach(data.vertexIndices, id: \.self) { index in
                    switch data.vertexes[index] {
                    case is UserVertex:
                        UserVertexView(data: $data.vertexes[index]) {
                            data.handle(isPressed: $0)
                        }
                        
                    case is BankVertex:
                        BankVertexView(data: $data.vertexes[index]) {
                            
                        }
                        .environmentObject(data)
                        
                    case is CardVertex:
                        CardVertexView(data: $data.vertexes[index]) {
                            withAnimation(.spring()) {
                                self.data.isDetailViewShown = true
                            }
                        }
                        .environmentObject(data)
                        
                    case is InsuranceVertex:
                        InsuranceVertexView(data: $data.vertexes[index]) {
                            
                        }
                        .environmentObject(data)
                        
                    case is MobileVertex:
                        MobileVertexView(data: $data.vertexes[index]) {
                            
                        }
                        .environmentObject(data)
                        
                    case is CoworkerVertex:
                        CoworkerVertexView(data: $data.vertexes[index]) {
                            
                        }
                        .environmentObject(data)
                        
                    default:
                        Text("")
                    }
                }
                
                
                // Deposit
                if data.depositVertex != nil {
                    DepositVertexView(data: $data.depositVertex) {
                        data.handle(status: $0)
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    private var cardsView: some View {
        GeometryReader { proxy in
            if data.isDetailViewShown {
                VStack {
                    Spacer()
                    
                    HikeView(hike: ModelData().hikes[0])
                        .frame(alignment: .bottom)
                }
                .transition(.moveAndFade)
                .frame(height: proxy.size.height)
            }
        }
    }
    
    private var editButton: some View {
        Button(action: { data.addDeposit() }) {
            ZStack {
                // Background
                Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1))
                
                // Image
                Image(systemName: "dollarsign.circle")
                    .scaleEffect(1.5)
                    .foregroundColor(.white)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(24)
        }
        .buttonStyle(buttonStyle)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
    }
    
    private var dismissButton: some View {
        Button(action: { data.dismiss() }) {
            ZStack {
                // Background
                Color(#colorLiteral(red: 0.4929926395, green: 0.2711846232, blue: 0.9990822673, alpha: 1))
                
                // Image
                Image(systemName: "circle.grid.3x3")
                    .scaleEffect(1.2)
                    .foregroundColor(.white)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(24)
        }
        .buttonStyle(buttonStyle)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 30))
    }
    
    private var thumbnails: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Group {
                if !data.thumbnails.isEmpty {
                    HStack(spacing: 15) {
                        ForEach(Array(data.thumbnails.enumerated()), id: \.element) { (i, data) in
                            ThumbnailView(data: data, index: i) {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .transition(.move(edge: .trailing))
                }
            }
            .frame(height: 50)
        }
    }
}

#if DEBUG
struct Graph3View_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = Graph3View()
        
        Group {
            view
                .previewDevice("iPhone 12")
                .preferredColorScheme(.dark)
        }
    }
}
#endif


struct ContentView22: View {
    @State private var showDetails = false

    var body: some View {
        VStack {
            Button("Press to show details") {
                withAnimation {
                    showDetails.toggle()
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                Group {
                    if showDetails {
                        HStack(spacing: 15) {
                            ForEach(0..<5, id: \.self) { i in
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                    .animation(Animation.spring(dampingFraction: 0.5)
                                                .speed(2)
                                                .delay(0.03 * TimeInterval(i)))
                            }
                        }
                        .padding(.horizontal, 20)
                        .transition(.move(edge: .trailing))
                    }
                }
                .frame(height: 50)
            }
        }
    }
}

