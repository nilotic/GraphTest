//
//  GraphTestApp.swift
//
//  Created by Den Jo on 2021/05/04.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

@main
struct GraphTestApp: App {
    var body: some Scene {
        WindowGroup {
            TabbarView()
//            ContentView()
//            DemoDragRelocateView()
        }
    }
}



struct ContentView: View {
    
    var body: some View {
        HStack {
            VStack {
                DragableImage(title: "50,000")
                
                DragableImage(title: "15,000")
            }
            
            VStack {
                DragableImage(title: "7,000")
                
                DragableImage(title: "8,500")
            }
            
            DroppableArea()
        }.padding(40)
    }
    
    struct DragableImage: View {
        let title: String
        
        var body: some View {
            Text(title)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .padding(2)
                .overlay(Circle().strokeBorder(Color.black.opacity(0.1)))
                .shadow(radius: 3)
                .padding(4)
                .onDrag {
                    NSItemProvider(object: title as NSString)
                    
                }
        }
    }
    
    struct DroppableArea: View {
        @State private var imageUrls: [Int: URL] = [:]
        @State private var active = 0
        
        var body: some View {
            let dropDelegate = MyDropDelegate(imageUrls: $imageUrls, active: $active)
            
            return VStack {
                HStack {
                    GridCell(active: self.active == 1, url: imageUrls[1])
                    
                    GridCell(active: self.active == 3, url: imageUrls[3])
                }
                
                HStack {
                    GridCell(active: self.active == 2, url: imageUrls[2])

                    GridCell(active: self.active == 4, url: imageUrls[4])
                }
                
            }
            .background(Rectangle().fill(Color.gray))
            .frame(width: 300, height: 300)
            .onDrop(of: ["public.file-url"], delegate: dropDelegate)
            
        }
    }
    
    struct GridCell: View {
        let active: Bool
        let url: URL?
        
        var body: some View {
            let img = Image(uiImage: url != nil ? UIImage(contentsOfFile: url?.absoluteString ?? "") ?? UIImage() : UIImage())
                .resizable()
                .frame(width: 150, height: 150)
            
            return Rectangle()
                .fill(self.active ? Color.green : Color.clear)
                .frame(width: 150, height: 150)
                .overlay(img)
        }
    }
    
    struct MyDropDelegate: DropDelegate {
        @Binding var imageUrls: [Int: URL]
        @Binding var active: Int
        
        func validateDrop(info: DropInfo) -> Bool {
            return info.hasItemsConforming(to: ["public.file-url"])
        }
        
        func dropEntered(info: DropInfo) {
            log(.info, info)
            // Vibration
        }
        
        func performDrop(info: DropInfo) -> Bool {
            // Vibration
            
            
            let gridPosition = getGridPosition(location: info.location)
            self.active = gridPosition
            
            if let item = info.itemProviders(for: ["public.file-url"]).first {
                item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                    DispatchQueue.main.async {
                        if let urlData = urlData as? Data {
                            self.imageUrls[gridPosition] = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                        }
                    }
                }
                
                return true
                
            } else {
                return false
            }

        }
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            self.active = getGridPosition(location: info.location)
                        
            return nil
        }
        
        func dropExited(info: DropInfo) {
            self.active = 0
        }
        
        func getGridPosition(location: CGPoint) -> Int {
            if location.x > 150 && location.y > 150 {
                return 4
            } else if location.x > 150 && location.y < 150 {
                return 3
            } else if location.x < 150 && location.y > 150 {
                return 2
            } else if location.x < 150 && location.y < 150 {
                return 1
            } else {
                return 0
            }
        }
    }
}


import UniformTypeIdentifiers

struct GridData: Identifiable, Equatable {
    let id: Int
}

//MARK: - Model

class Model: ObservableObject {
    @Published var data: [GridData]

    let columns = [
        GridItem(.fixed(160)),
        GridItem(.fixed(160))
    ]

    init() {
        data = Array(repeating: GridData(id: 0), count: 100)
        for i in 0..<data.count {
            data[i] = GridData(id: i)
        }
    }
}

//MARK: - Grid

struct DemoDragRelocateView: View {
    @StateObject private var model = Model()

    @State private var dragging: GridData?

    var body: some View {
        ScrollView {
           LazyVGrid(columns: model.columns, spacing: 32) {
                ForEach(model.data) { d in
                    GridItemView(d: d)
                        .overlay(dragging?.id == d.id ? Color.white.opacity(0.8) : Color.clear)
                        .onDrag {
                            self.dragging = d
                            return NSItemProvider(object: String(d.id) as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
//                        .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(current: $dragging))
                }
            }.animation(.default, value: model.data)
        }
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}

struct DropOutsideDelegate: DropDelegate {
    @Binding var current: GridData?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}


//MARK: - GridItem

struct GridItemView: View {
    var d: GridData

    var body: some View {
        VStack {
            Text(String(d.id))
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 160, height: 240)
        .background(Color.green)
    }
}
