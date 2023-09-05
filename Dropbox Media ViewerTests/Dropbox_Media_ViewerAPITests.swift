//
//  Dropbox_Media_ViewerAPITests.swift
//  Dropbox Media ViewerTests
//
//  Created by Shumakov Dmytro on 05.09.2023.
//

import XCTest
@testable import Dropbox_Media_Viewer

final class Dropbox_Media_ViewerAPITests: XCTestCase {
    
    // var apiManager: APIManager!

    override func setUpWithError() throws {
        try  super.setUpWithError()
        //
        // apiManager = APIManager()
    }

    override func tearDownWithError() throws {
        // apiManager = nil
        //
        try super.tearDownWithError()
    }

    func testCheckAccessToken() {
        let expectation = XCTestExpectation(description: "CheckAccessToken completion called")
        
        APIManager.checkAccessToken { success in
            XCTAssertTrue(success, "Access token should be valid")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchMediaFilesForFirstTime() {
        let expectation = XCTestExpectation(description: "FetchMediaFilesForFirstTime completion called")
        
        APIManager.fetchMediaFilesForFirstTime { mediaFiles in
            XCTAssertNotNil(mediaFiles, "Media files should not be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchMoreMediaFiles() {
        let expectation = XCTestExpectation(description: "FetchMoreMediaFiles completion called")
                
        APIManager.fetchMoreMediaFiles { mediaFiles, canUsersDownloadMore in
            XCTAssertNotNil(mediaFiles, "Media files should not be nil")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
