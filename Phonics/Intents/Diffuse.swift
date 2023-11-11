//
//  Diffuse.swift
//  Phonics
//
//  Created by Chiyoi on 11/6/23.
//

import AppIntents
import CoreML
import Foundation

import StableDiffusion

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#elseif os(visionOS)
#endif

struct Diffuse: ProgressReportingIntent {
    
    static let title: LocalizedStringResource = "Diffuse"
    static let description = IntentDescription("Diffuse with prompt.")
    
    static var parameterSummary: some ParameterSummary {
        Summary("Diffuse with \(\.$prompt)") {
            \.$stepCount
            \.$seed
        }
    }
    
    @Parameter(
        title: "Prompt",
        description: "(Text) Prompt to diffuse."
    ) var prompt: String
    
    @Parameter(
        title: "Step Count",
        description: "(Integer) Diffusion steps. (optional)",
        default: 30,
        controlStyle: .stepper
    ) var stepCount: Int
    
    @Parameter(
        title: "Seed",
        description: "(Integer) Random seed. (optional)",
        controlStyle: .field
    ) var seed: Int?
    
    static var resourceURL: URL? {
        Bundle.main.url(
            forResource: "coreml-Ojimi-anime-kawai-diffusion-cpu-ne-6bit",
            withExtension: nil
        )
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<IntentFile> {
        print("Diffuse v0.1.7-rc2")
        
        let seed = seed != nil ? UInt32(seed!) : UInt32.random(in: 0...UInt32.max)
        let targetSize: Float = 512
        
        let image = try Self.diffuse(
            with: prompt,
            stepCount: stepCount,
            seed: seed,
            targetSize: targetSize
        ) { pipelineProgress in
            if progress.isIndeterminate {
                progress.totalUnitCount = Int64(stepCount)
            }
            progress.completedUnitCount = Int64(pipelineProgress.step)
            if progress.completedUnitCount % 10 == 0 {
                print("Pipeline progress: \(progress.completedUnitCount)/\(progress.totalUnitCount)")
            }
            return true
        }
        
        let data = try Self.cgImageData(cgImage: image)
        let filename = "\(prompt)-\(seed).png"
        return .result(value: IntentFile(data: data, filename: filename, type: .png))
    }
    
    static func diffuse(
        with prompt: String,
        stepCount: Int,
        seed: UInt32,
        targetSize: Float,
        progressHandler: (PipelineProgress) -> Bool
    ) throws -> CGImage {
        guard let resourceURL = Self.resourceURL else {
            throw Error.failedLoadingResource
        }
        
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndNeuralEngine
        
        let pipeline = try StableDiffusionPipeline(
            resourcesAt: resourceURL,
            controlNet: [],
            configuration: config,
            disableSafety: true,
            reduceMemory: false,
            useMultilingualTextEncoder: false,
            script: .latin
        )
        
        print("Load resources.")
        try pipeline.loadResources()
        
        var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: prompt)
        pipelineConfig.stepCount = stepCount
        pipelineConfig.seed = seed
        pipelineConfig.targetSize = targetSize
        
        print("Generate images.")
        let images = try pipeline.generateImages(
            configuration: pipelineConfig,
            progressHandler: progressHandler
        )
        
        guard let image = images[0] else {
            throw Error.failedGettingResult
        }
        return image
    }
    
    static func cgImageData(cgImage: CGImage) throws -> Data  {
#if os(macOS)
        let bitmap = NSBitmapImageRep(cgImage: cgImage)
        guard let data = bitmap.representation(using: .png, properties: [:]) else {
            throw Error.failedGettingResult
        }
#elseif os(iOS)
        let uiImage = UIImage(cgImage: cgImage)
        guard let data = uiImage.pngData() else {
            throw Error.failedGettingResult
        }
#endif
        return data
    }
    
    enum Error: Swift.Error {
        case failedLoadingResource, failedRunningDiffuse, failedGettingResult
    }
}
