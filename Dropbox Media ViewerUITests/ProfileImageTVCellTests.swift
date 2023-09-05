//
//  ProfileImageTVCellTests.swift
//  Dropbox Media ViewerUITests
//
//  Created by Shumakov Dmytro on 05.09.2023.
//

import XCTest
@testable import Dropbox_Media_Viewer

class ProfileImageTVCellTests: XCTestCase {
    
    var cell: ProfileImageTVCell!
    var user: UserML!

    override func setUpWithError() throws {
        continueAfterFailure = false
        cell = ProfileImageTVCell()
        user = UserML(id: "123", name: "Name", email: "Email", photoURL: "https://example.com/profile.jpg")
    }

    override func tearDownWithError() throws {
        cell = nil
    }

    func testConfigureCell() throws {
        // Configure the cell with the sample UserML
        cell.configureCell(user)
        
        // Assert that the activity indicator is animating
        XCTAssertTrue(cell.activityIndicator.isAnimating, "Activity indicator should be animating")
        
        // Simulate image download by directly setting the image (you can also use a test image)
        let testImage = UIImage(named: "test_profile_image")
        cell.profileImageView.image = testImage
        
        // Assert that the activity indicator has stopped animating
        XCTAssertFalse(cell.activityIndicator.isAnimating, "Activity indicator should have stopped animating")
        
        // Assert that the profileImageView has the test image (replace "test_profile_image" with the actual test image name)
        XCTAssertEqual(cell.profileImageView.image, testImage, "Profile image should match the test image")
    }


    func testPrepareForReuse() {
        // Configure the cell with some data
        cell.configureCell(user)
        
        // Call prepareForReuse
        cell.prepareForReuse()
        
        // Assert that the activity indicator has stopped animating
        XCTAssertFalse(cell.activityIndicator.isAnimating, "Activity indicator should have stopped animating")
        
        // Assert that the profileImageView's image is nil after prepareForReuse
        XCTAssertNil(cell.profileImageView.image, "Profile image should be nil after prepareForReuse")
    }
}
