//
//  MediaPreviewTVCellTests.swift
//  Dropbox Media ViewerUITests
//
//  Created by Shumakov Dmytro on 05.09.2023.
//

import XCTest
@testable import Dropbox_Media_Viewer

final class MediaPreviewTVCellTests: XCTestCase {
    
    var cell: MediaPreviewTVCell!
    var mediaFile: MediaFile!

    override func setUpWithError() throws {
        continueAfterFailure = false
        cell = MediaPreviewTVCell()
        
        let mediaFile = MediaFile(id: "1", name: "TestMedia",
                                  size: 1024,
                                  path: "test.jpg",
                                  modified: Date(),
                                  image: nil,
                                  videoURL: nil,
                                  mediaType: .photo)
    }

    override func tearDownWithError() throws {
        cell = nil
        mediaFile = nil
    }

    func testConfigureCell() {
        
        let mockDelegate: FileDetailsDelegate? = nil
        cell.configureCell(mediaFile, delegate: mockDelegate)
        
        XCTAssertEqual(cell.nameLabel.text, "TestMedia", "Name should match")
        XCTAssertEqual(cell.sizeLabel.text, "1.0 KB", "Size should match")
        XCTAssertEqual(cell.videoMarkImageView.isHidden, mediaFile.mediaType == .photo, "VideoMark should be visible for video")
    }
    
    func testSelectButtonAction() {
        class MockDelegate: MediaPreviewDelegate {
            var didCallGetSelectedMediaFileDetails = false
            func getSelectedMediaFileDetails(id: String) {
                didCallGetSelectedMediaFileDetails = true
            }
        }
        
        let mockDelegate = MockDelegate()
                
        cell.configureCell(mediaFile, delegate: mockDelegate)
                
        cell.selectButton.sendActions(for: .touchUpInside)
                
        XCTAssertTrue(mockDelegate.didCallGetSelectedMediaFileDetails, "Delegate method should be called on button press")
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
