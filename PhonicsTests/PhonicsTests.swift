//
//  PhonicsTests.swift
//  PhonicsTests
//
//  Created by Chiyoi on 11/5/23.
//

import XCTest
import AppIntents
@testable import Phonics

final class PhonicsTests: XCTestCase {
    
    func testReourceURLAvailable() throws {
        guard let u = Diffuse.resourceURL else {
            assertionFailure()
            return
        }
        
        add(XCTAttachment(string: u.absoluteString))
    }
    
    func testDiffuse() async throws {
        let diffuse = Diffuse()
        diffuse.prompt = "cute, loli"
        
        guard let file = try await diffuse.perform().value else {
            assertionFailure()
            return
        }
        
        add(XCTAttachment(data: file.data))
    }
}
