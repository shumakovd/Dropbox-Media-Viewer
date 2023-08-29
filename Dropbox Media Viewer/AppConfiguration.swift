//
//  AppConfiguration.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit

// MARK: - Storyboards -

// Main Storyboards
let kAuthStoryboard = UIStoryboard(name: "Auth", bundle: nil)
let kMainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let kPopupStoryboard = UIStoryboard(name: "Popup", bundle: nil)

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
    
    enum PopupStoryboard {
      //
    }
   
    enum MediaStoryboard {
        static let kMediaVC = "MediaVC"
        static let kMediaDetailsVC = "MediaDetailsVC"
    }
    
    enum ProfileStoryboard {
        static let kProfileVC = "ProfileVC"
        static let kSettingsVC = "SettingsVC"
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
  
    // MARK: - Methods -
    
    // MARK: - Cache Methods -
    
    
}
