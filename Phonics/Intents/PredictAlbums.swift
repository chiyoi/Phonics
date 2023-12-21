//
//  PredictAlbums.swift
//  Phonics
//
//  Created by Chiyoi on 11/5/23.
//

import AppIntents
import SwiftUI

struct PredictAlbums: AppIntent {
    
    static var title: LocalizedStringResource = "Predict Albums"
    static var description = IntentDescription("Predict albums of photos.")
    
    static var parameterSummary: some ParameterSummary {
        Summary("Predict Albums of \(\.$photos)")
    }
    
    @Parameter(
        title: "Photos",
        description: "(Images) Photos to predict.",
        supportedTypeIdentifiers: ["public.image"],
        inputConnectionBehavior: .connectToPreviousIntentResult
    ) public var photos: [IntentFile]
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
        var predictions: [String] = []
        
        let model = try Phonics3(configuration: .init())
        
        for photo in photos {
            predictions.append(try await Self.predict(albumOf: photo, using: model))
        }
        
        return .result(value: predictions)
    }
    
    static func predict(albumOf photo: IntentFile, using model: Phonics3) async throws -> String {
#if os(macOS)
        guard let image = NSImage(data: photo.data) else {
            throw Error.failedGettingImage
        }
        
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw Error.failedGettingImage
        }
#elseif os(iOS)
        guard let image = UIImage(data: photo.data) else {
            throw Error.failedGettingImage
        }
        
        guard let cgImage = image.cgImage else {
            throw Error.failedGettingImage
        }
#endif
        
        let input = try Phonics3Input(imageWith: cgImage)
        
        let res = try await model.prediction(input: input)
        
        return res.target
    }
    
    enum Error: Swift.Error {
        
        case failedGettingImage
    }
}
