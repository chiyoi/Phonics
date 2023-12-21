//
//  ContentView.swift
//  Phonics
//
//  Created by Chiyoi on 11/6/23.
//

import SwiftUI

struct PhonicsView: View {
    @State var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "photo")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding(5)
                Text("Phonics")
            }
            .padding()
        }
        .navigationTitle("Phonics")
    }
}

#Preview {
    PhonicsView()
}
