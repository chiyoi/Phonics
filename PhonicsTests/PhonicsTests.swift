//
//  PhonicsTests.swift
//  PhonicsTests
//
//  Created by Chiyoi on 11/5/23.
//

import XCTest
@testable import Phonics

final class PhonicsTests: XCTestCase {
    
    func testReourceURLAvailable() throws {
        guard let u = Diffuse.resourceURL else {
            assertionFailure()
            return
        }
        
        add(XCTAttachment(string: u.absoluteString))
    }
}
