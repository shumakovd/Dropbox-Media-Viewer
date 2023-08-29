//
//  MainTabBarController.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit

enum MainTabBarButtonType {
    case map, home, profile
}

class MainTabBarController: UITabBarController {
    
            
    // MARK: - Properties -
    
    var indexWillBeSelected: Int = 0
    
    // Tab Bar
    private let customTabBar = UIView()
    
    // Timer
    private var loadingTimer: Timer?
    
    // Buttons
    private var mediaButton = UITabBarButton()
    private var profileButton = UITabBarButton()        
    
    // Feedback
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    // Selected Index
    override var selectedIndex: Int {
        willSet {
            switch newValue {
            case 0:
                mediaButton.setImage(UIImage(named: "tabbar_map_enabled_icon"), for: .normal)
                profileButton.setImage(UIImage(named: "tabbar_profile_disabled_icon"), for: .normal)
            
            case 1:
                mediaButton.setImage(UIImage(named: "tabbar_map_enabled_icon"), for: .normal)
                profileButton.setImage(UIImage(named: "tabbar_profile_disabled_icon"), for: .normal)
            
            default:
                break
            }
        }
    }
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the default tab bar
        tabBar.isHidden = true
        
        // Call Methods
        setupTabBar()
        getUserData()
        listenNotifications()
    }
    
    deinit {
        removeNotifications()
    }
    
    
    // MARK: - Methods -

    func listenNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(hideCustomTabBar),
                                       name: .hideTabBar,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(showCustomTabBar),
                                       name: .showTabBar,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(enableTabBar),
                                       name: .enableTabBarItems,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(disableTabBar),
                                       name: .disableTabBarItems,
                                       object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Private Methods -
    
    private func setupTabBar() {
        
        // Select first index
        selectedIndex = indexWillBeSelected
        
        // Set up the custom tab bar
        customTabBar.cornerRadiusView = 32
        customTabBar.backgroundColor = UIColor.lightGray
        
        customTabBar.tabbarDrowShadow()
                
        view.addSubview(customTabBar)
                
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            customTabBar.widthAnchor.constraint(equalToConstant: 136),
            customTabBar.heightAnchor.constraint(equalToConstant: 64)
        ])

        // Add buttons to the custom tab bar
        mediaButton.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addSubview(mediaButton)
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.addSubview(profileButton)

        // Set up constraints for the buttons
        NSLayoutConstraint.activate([
            mediaButton.topAnchor.constraint(equalTo: customTabBar.topAnchor, constant: 16),
            mediaButton.leadingAnchor.constraint(equalTo: customTabBar.leadingAnchor, constant: 16),
            mediaButton.widthAnchor.constraint(equalToConstant: 32),
            mediaButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: customTabBar.topAnchor, constant: 16),
            profileButton.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor, constant: -16),
            profileButton.widthAnchor.constraint(equalToConstant: 32),
            profileButton.heightAnchor.constraint(equalToConstant: 32)
        ])


        // Add Target to buttons
        
        // Media Tap
        mediaButton.addTarget(self, action: #selector(mediaTapped), for: .touchUpInside)
              
        // Profile Short Tap
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
    }
    
    
    // MARK: - Network Methods -
    
    private func getUserData() {
//        disableTabBar()
//        AppConfiguration.getUserDataFromDatabase() { result in
//            if result {
//                self.enableTabBar()
//            }
//        }
    }
    
    
    // MARK: - Tab Bar Action Methods -
    
    // MARK: - Map
    
    @objc private func mediaTapped() {
        // Change Index
        selectedIndex = 0
    }
    
    // MARK: - Profile
        
    @objc private func profileTapped() {
        // Change Index
        selectedIndex = 1
    }
  
    
    // MARK: - Notifications Methods -
    
    @objc private func enableTabBar() {
        mediaButton.isEnabled = true
        profileButton.isEnabled = true
    }

    @objc private func disableTabBar() {
        mediaButton.isEnabled = false
        profileButton.isEnabled = false
    }
            
    // Method to hide the custom tab bar
    @objc private func hideCustomTabBar() {
        if customTabBar.isHidden == true {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut, animations: {
            
            self.customTabBar.isHidden = true
            self.customTabBar.transform = CGAffineTransform(translationX: 0, y: self.customTabBar.frame.height)
            
        }, completion: nil)
    }

    // Method to show the custom tab bar
    @objc private func showCustomTabBar() {
        if customTabBar.isHidden == false {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut, animations: {
            
            self.customTabBar.isHidden = false
            self.customTabBar.transform = CGAffineTransform.identity
            
        }, completion: nil)
    }
}
