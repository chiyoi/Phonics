//
//  Diffuse.swift
//  Phonics
//
//  Created by chiyoi on 11/10/23.
//

import SwiftUI

struct DiffuseView: View {
    
    @State var prompt: String = ""
    @State var stepCount: Int = 30
    @State var seed: String = ""

    var body: some View {
        VStack {
            GroupBox {
                VStack {
                    HStack {
                        Text("Prompt")
                        TextField("Prompt", text: $prompt)
                    }
                    HStack {
                        Text("Step Count")
                        Stepper(value: $stepCount, in: 0...50, step: 5) {
                            Text("\(stepCount)")
                        }
                        Spacer()
                    }
                    HStack {
                        Text("Seed")
                        TextField("Seed", text: $seed)
                    }
                }
            }
            Image(systemName: "photo")
            Spacer()
        }
        Spacer()
    }
}

#Preview {
    DiffuseView()
}
