//
//  AppDelegate.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit
import Pushwoosh
import SwiftyDropbox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        // Cache Manager
        let observer = MyCacheObserver()
        CacheManager.shared.addObserver(observer)
        
        // API Auth
        APIManager.setup()
        
        // Pushwoosh
        Pushwoosh.sharedInstance().delegate = self
        Pushwoosh.sharedInstance().registerForPushNotifications()
        
        // Event
        let attributes: [String : Any] = [
           "application_version" : "1.0.0",
           "device_type" : 1
        ]
        PWInAppManager.shared().postEvent("PW_ApplicationOpen", withAttributes: attributes)
                                    
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let authResult = DropboxClientsManager.handleRedirectURL(url) { authResult in
            switch authResult {
            case .success(let token):
                
                APIManager.checkAccessToken { result in
                    if result {
                        // Cache Access Token
                        CacheManager.shared.set(key: .accessToken, value: token.accessToken)
                        
                        // Successfully Authentication
                        AppConfiguration.mainVC()
                    }
                }
                
            case .cancel:
                print("API Auth canceled")
                
            case .error(let error, let description):
                print("API Auth Error: \(error) - \(description)")
                
            default:
                break
            }
        }
        
        return authResult
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state;
        // here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        CoreDataManager.shared.saveContext()
    }
}

extension AppDelegate: PWMessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Pushwoosh.sharedInstance().handlePushRegistration(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Pushwoosh.sharedInstance().handlePushReceived(userInfo)
        completionHandler(.noData)
    }
    
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageReceived message: PWMessage) {
        print("onMessageRecieved: ", message.payload?.description)
    }
    
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageOpened message: PWMessage) {
        print("onMessageOpened: ", message.payload?.description)
    }
}
