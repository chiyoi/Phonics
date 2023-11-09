//
//  Diffuse.swift
//  Phonics
//
//  Created by Chiyoi on 11/6/23.
//

import AppIntents
import Foundation
import StableDiffusion
import CoreML

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#elseif os(visionOS)
#endif

struct Diffuse: AppIntent {
    
    static var title: LocalizedStringResource = "Diffuse"
    static var description = IntentDescription("Diffuse with prompt.")
    
    static var parameterSummary: some ParameterSummary {
        Summary("Diffuse with \(\.$prompt).")
    }
    
    @Parameter(
        title: "Prompt",
        description: "Prompt to diffuse."
    ) var prompt: String
    
    @Parameter(
        title: "Step Count",
        description: "Diffusion steps.",
        default: 30
    ) var stepCount: Int
    
    @Parameter(
        title: "Seed",
        description: "Random seed."
    ) var seed: Int?
    
    static var resourceURL: URL? {
        Bundle.main.url(
            forResource: "coreml-Ojimi-anime-kawai-diffusion-cpu-ne-6bit",
            withExtension: nil
        )
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<IntentFile> {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndNeuralEngine
        
        guard let resourceURL = Self.resourceURL else {
            throw Error.failedLoadingResource
        }
        
        let pipeline = try StableDiffusionPipeline(
            resourcesAt: resourceURL,
            controlNet: [],
            configuration: config,
            disableSafety: true,
            reduceMemory: false,
            useMultilingualTextEncoder: false,
            script: .latin
        )
        
        try pipeline.loadResources()
        
        let seed = seed != nil ? UInt32(seed!) : UInt32.random(in: 0...UInt32.max)
        let targetSize: Float = 512
        
        var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: prompt)
        pipelineConfig.stepCount = stepCount
        pipelineConfig.seed = seed
        pipelineConfig.targetSize = targetSize
        
        let images = try pipeline.generateImages(configuration: pipelineConfig)
        
        guard let image = images[0] else {
            throw Error.failedGettingResult
        }
        
#if os(macOS)
        let bitmap = NSBitmapImageRep(cgImage: image)
        guard let data = bitmap.representation(using: .png, properties: [:]) else {
            throw Error.failedGettingResult
        }
#endif
        
        let filename = "\(prompt)-\(seed).png"
        return .result(value: IntentFile(data: data, filename: filename, type: .png))
    }
    
    enum Error: Swift.Error {
        case failedLoadingResource, failedGettingResult
    }
}
