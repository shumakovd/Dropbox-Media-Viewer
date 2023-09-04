//
//  AuthVC.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit

class AuthVC: BaseVC {
    
    // MARK: - IBOutlets -
    
    @IBOutlet private weak var authWithDropBoxButton: UIButton!
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - IBActions -
    
    @IBAction private func loginWuthDropbox(_ sender: UIButton) {
        APIManager.authorizeFromControllerV2(viewController: self)
    }
}
