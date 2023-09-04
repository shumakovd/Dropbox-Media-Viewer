//
//  AppConfiguration.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit
import AVFoundation
import SwiftyDropbox

// MARK: - Storyboards -

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

// Main Storyboards
let kAuthStoryboard = UIStoryboard(name: "Auth", bundle: nil)
let kMainStoryboard = UIStoryboard(name: "Main", bundle: nil)

// Tab Bar Storyboards
let kMediaStoryboard = UIStoryboard(name: "Media", bundle: nil)
let kProfileStoryboard = UIStoryboard(name: "Profile", bundle: nil)


// MARK: - ViewControllers -

enum ViewControllerIDs {
    
    enum AuthStoryboard {
        static let kAuthVC = "AuthVC"
    }
    
    enum MainStoryboard {
        static let kMainTabBarController = "MainTabBarController"
    }

    enum MediaStoryboard {
        static let kMediaVC = "MediaVC"
        static let kMediaDetailsVC = "MediaDetailsVC"
    }
    
    enum ProfileStoryboard {
        static let kProfileVC = "ProfileVC"
    }
}


// MARK: - App Configutration -

class AppConfiguration {
    
    // Shared Instance
    static var shared: AppConfiguration = {
        return AppConfiguration()
    }()
    
    private init() {}
    
    
    // MARK: - Properties -   
    
    static var userModel: UserML?
    static var accessToken: String?
    
    
    // MARK: - Methods -
        
    
    // MARK: - Navigation Methods
    
    static func mainVC(_ index: Int = 0) {
        let mainVC = kMainStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.MainStoryboard.kMainTabBarController) as! MainTabBarController
        mainVC.indexWillBeSelected = index
        APP_DELEGATE.window?.rootViewController = mainVC
    }
        
    static func authVC(withAnimation: Bool = false) {
        var rootVC: UIViewController?
                
        rootVC = kAuthStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.AuthStoryboard.kAuthVC) as? AuthVC
                        
        let navigationController = UINavigationController(rootViewController: rootVC ?? UIViewController())
        APP_DELEGATE.window?.rootViewController = navigationController
        
        if withAnimation {
            // A mask of options indicating how you want to perform the animations.
            let options: UIView.AnimationOptions = .transitionCrossDissolve

            // The duration of the transition animation, measured in seconds.
            let duration: TimeInterval = 0.3

            // Creates a transition animation.
            UIView.transition(with: APP_DELEGATE.window ?? UIWindow(), duration: duration, options: options, animations: {}, completion:
            { completed in
                // maybe do something on completion here
            })
        }
    }
    
    
    // MARK: - Media Files Methods
    
    static func getMediaType(from fileName: String) -> MediaType? {
        if fileName.lowercased().hasSuffix(".jpg") || fileName.lowercased().hasSuffix(".jpeg") {
            return .photo
        } else if fileName.lowercased().hasSuffix(".mp4") {
            return .video
        }
        return nil
    }
    
    static func generateThumbnail(forVideoAt videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
                
        // First Second
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}
