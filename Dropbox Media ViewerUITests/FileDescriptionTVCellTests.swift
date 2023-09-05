//
//  FileDescriptionTVCellTests.swift
//  Dropbox Media ViewerUITests
//
//  Created by Shumakov Dmytro on 05.09.2023.
//

import XCTest
@testable import Dropbox_Media_Viewer

final class FileDescriptionTVCellTests: XCTestCase {
    
    var cell: FileDescriptionTVCell!

    override func setUpWithError() throws {
        continueAfterFailure = false
        cell = FileDescriptionTVCell()
    }

    override func tearDownWithError() throws {
        cell = nil
    }

    func testConfigureCell() throws {
        // Create a sample MediaFile
        let mediaFile = MediaFile(id: "1",
                                  name: "TestFile.jpg",
                                  size: 1024,
                                  path: "path/to/file",
                                  modified: Date(),
                                  image: nil,
                                  videoURL: nil,
                                  mediaType: .photo)
        
        // Configure the cell with the sample MediaFile
        cell.configureCell(mediaFile)
        
        // Assert that the labels in the cell are set correctly
        XCTAssertEqual(cell.nameLabel.text, "TestFile.txt", "Name label should match")
        XCTAssertEqual(cell.sizeLabel.text, "1.0 KB", "Size label should match")
        XCTAssertTrue(cell.modifiedLabel.text?.starts(with: "Modified: ") == true, "Modified label should start with 'Modified: '")
    }

    func testPrepareForReuse() {
        // Configure the cell with some data
        let mediaFile = MediaFile(id: "1",
                                  name: "TestFile.jpg",
                                  size: 1024,
                                  path: "path/to/file",
                                  modified: Date(),
                                  image: nil,
                                  videoURL: nil,
                                  mediaType: .photo)
        
        cell.configureCell(mediaFile)
        
        // Call prepareForReuse
        cell.prepareForReuse()
        
        // Assert that labels are reset to their initial state
        XCTAssertEqual(cell.nameLabel.text, nil, "Name label should be nil after prepareForReuse")
        XCTAssertEqual(cell.sizeLabel.text, nil, "Size label should be nil after prepareForReuse")
        XCTAssertEqual(cell.modifiedLabel.text, nil, "Modified label should be nil after prepareForReuse")
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
