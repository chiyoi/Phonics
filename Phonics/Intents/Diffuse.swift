//
//  Diffuse.swift
//  Phonics
//
//  Created by Chiyoi on 11/6/23.
//

import AppIntents
import Foundation
import StableDiffusion

struct Diffuse: AppIntent {
    
    static var title: LocalizedStringResource = "Diffuse"
    static var description = IntentDescription("Diffuse with prompt.")
    
    static var resourceURL: URL? {
        Bundle.main.url(
            forResource: "coreml-Ojimi-anime-kawai-diffusion-cpu-ne-6bit",
            withExtension: nil
        )
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        return .result(value: "Test")
    }
}
