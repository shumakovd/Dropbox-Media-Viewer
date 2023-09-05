//
//  Dropbox_Media_ViewerUITests.swift
//  Dropbox Media ViewerUITests
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import XCTest
@testable import Dropbox_Media_Viewer

final class Dropbox_Media_ViewerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
    }

    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()

    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
            
        }
    }
}
