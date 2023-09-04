//
//  NotificationExt.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import Foundation

extension Notification.Name {
    
    // Main Tab Bar Controller
    static let hideTabBar = NSNotification.Name("hideTabBar")
    static let showTabBar = NSNotification.Name("showTabBar")
    //
    static let enableTabBarItems = NSNotification.Name("enableTabBarItems")
    static let disableTabBarItems = NSNotification.Name("disableTabBarItems")
    //
    static let updateModel = NSNotification.Name("updateModel")
}
