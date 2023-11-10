//
//  ContentView.swift
//  Phonics
//
//  Created by Chiyoi on 11/6/23.
//

import SwiftUI

struct PhonicsView: View {
    @State var page: Page = .Welcome
    @State var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $page) {
                NavigationLink("Phonics", value: Page.Welcome)
                Divider()
                NavigationLink("Predict Albums", value: Page.PredictAlbums)
                NavigationLink("Diffuse", value: Page.Diffuse)
            }
        } detail: {
            switch page {
            case .Welcome:
                VStack {
                    VStack {
                        Image(systemName: "photo")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            .padding(5)
                        Text("Phonics v0.1.7")
                    }
                    .padding()
                    
                    HStack {
                        Button {
                            page = .PredictAlbums
                        } label: {
                            Text("Predict Album")
                        }
                        
                        Button {
                            page = .Diffuse
                        } label: {
                            Text("Diffuse")
                        }
                    }
                }
            case .PredictAlbums:
                PredictAlbumView()
            case .Diffuse:
                DiffuseView()
            }
        }
        .navigationTitle("Phonics")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    page = .Welcome
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .opacity(page == .Welcome ? 0 : 1)
            }
        }
    }
    
    enum Page {
        case Welcome, PredictAlbums, Diffuse
    }
}

#Preview {
    PhonicsView()
}
