//
//  FileDetailsTVCellTests.swift
//  Dropbox Media ViewerUITests
//
//  Created by Shumakov Dmytro on 05.09.2023.
//

import XCTest
import AVFoundation
@testable import Dropbox_Media_Viewer

final class FileDetailsTVCellTests: XCTestCase {
    
    var cell: FileDetailsTVCell!
    var mediaFile: MediaFile!

    override func setUpWithError() throws {                
        continueAfterFailure = false
        //
        cell = FileDetailsTVCell()
    }

    override func tearDownWithError() throws {
        cell = nil
    }

    func testConfigureCellForImage() {
        
        let mediaFile = MediaFile(id: "1",
                                  name: "TestMedia",
                                  size: 1024,
                                  path: "test.jpg",
                                  modified: Date(),
                                  image: nil,
                                  videoURL: nil,
                                  mediaType: .photo)
                     
        let mockDelegate: FileDetailsDelegate? = nil
        cell.configureCell(mediaFile, delegate: mockDelegate)
           
        XCTAssertFalse(cell.playButton.isHidden, "Play button should be visible for images")
        XCTAssertTrue(cell.videoMarkImageView.isHidden, "Video mark should be hidden for images")
        XCTAssertEqual(cell.mediaImageView.image, mediaFile.image, "Media image should match")
    }
    
    func testConfigureCellForVideo() {
        let mediaFile = MediaFile(id: "1", name: "TestMedia",
                                  size: 1024,
                                  path: "test.mp4",
                                  modified: Date(),
                                  image: UIImage(named: "test_image"),
                                  videoURL: URL(string: "https://example.com/test.mp4"),
                                  mediaType: .video)
        
        let mockDelegate: FileDetailsDelegate? = nil
        cell.configureCell(mediaFile, delegate: mockDelegate)
        
        XCTAssertTrue(cell.playButton.isHidden, "Play button should be hidden for videos")
        XCTAssertTrue(cell.videoMarkImageView.isHidden, "Video mark should be hidden for videos")
        XCTAssertEqual(cell.mediaImageView.image, mediaFile.image, "Media image should match")
    }
    
    func testPlayAction() {
        
        let mockMediaFile: MediaFile? = nil
        let mockDelegate = MockDelegate()
        
        cell.configureCell(mockMediaFile, delegate: mockDelegate)
        cell.playAction(cell.playButton)
        XCTAssertTrue(mockDelegate.didCallStartVideoDownload, "Delegate method should be called on play action")
    }
    
    func testPlayPauseAction() {
        let mockPlayer = MockAVPlayer()
        cell.player = mockPlayer
        cell.playPauseAction(cell.playPauseButton)
        XCTAssertTrue(mockPlayer.didCallPlay || mockPlayer.didCallPause, "AVPlayer play/pause method should be called on play/pause action")
    }
    
    func testGoForwardAction() {
        let mockPlayer = MockAVPlayer()
        cell.player = mockPlayer
        cell.goForwardAction(cell.goForwardButton)
        XCTAssertTrue(mockPlayer.didCallSeek, "AVPlayer seek method should be called on go forward action")
    }
    
    func testGoBackwardAction() {
        let mockPlayer = MockAVPlayer()
        cell.player = mockPlayer
        cell.goBackwardAction(cell.goBackwardButton)
        XCTAssertTrue(mockPlayer.didCallSeek, "AVPlayer seek method should be called on go backward action")
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

class MockDelegate: FileDetailsDelegate {
    var didCallStartVideoDownload = false
    func startVideoDownload(withPath path: String) {
        didCallStartVideoDownload = true
    }
}

class MockAVPlayer: AVPlayer {
    var didCallPlay = false
    var didCallPause = false
    var didCallSeek = false
    
    override func play() {
        didCallPlay = true
    }
    
    override func pause() {
        didCallPause = true
    }
    
    override func seek(to time: CMTime) {
        didCallSeek = true
    }
}
