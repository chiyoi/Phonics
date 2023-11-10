//
//  ContentView.swift
//  Phonics
//
//  Created by Chiyoi on 11/6/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "photo")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Phonics v0.1.6")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
