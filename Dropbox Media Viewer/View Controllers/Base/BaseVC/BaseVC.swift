//
//  BaseVC.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit
import StoreKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    // MARK: - IBOutlets -
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: - Properties -
    
    private var showTabBar: Bool = false
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        listenNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Tab Bar
        // Check if the view controller being navigated to is a specific type
        if (self.navigationController?.viewControllers.last is MediaVC) ||
           (self.navigationController?.viewControllers.last is ProfileVC) {
            
            showTabBar = true

        } else {
            NotificationCenter.default.post(name: .hideTabBar, object: nil)
        }
    }
    
    deinit {
                
        if showTabBar == true {
            NotificationCenter.default.post(name: .showTabBar, object: nil)
        }
        
        removeNotifications()
    }
    
    
    // MARK: - Methods -
           
    
    // MARK: - Notification Methods -
    
    func listenNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    // MARK: - NSNotifications -
    
    @objc func keyboardWillHide(notification _: NSNotification) {
        // override in child class
    }

    @objc func keyboardWillShow(notification _: NSNotification) {
        // override in child class
    }
        
    
    // MARK: - Keyboard Methods -
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardWhenTappedOnView(_ view: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
