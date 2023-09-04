//
//  ProfileVC.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit

class ProfileVC: BaseVC {
    
    
    // MARK: - Properties -
    
    private var model: UserML?
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupTableView()
        downloadUserData()
    }
    
    
    // MARK: - Methods -
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cells
        ProfileImageTVCell.registerForTableView(aTableView: tableView)
        ProfileAdditionalInfoTVCell.registerForTableView(aTableView: tableView)
        ProfileControlElementsTVCell.registerForTableView(aTableView: tableView)
    }
    
    private func downloadUserData() {
        model = AppConfiguration.userModel
        
        // Content Inset
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        // Relaod Data
        tableView.reloadData()
    }
    
    private func clearCache() {
        ImageCache.shared.removeAllImages()
        // Relaod Data
        tableView.reloadData()
    }
    
    private func leaveFromAccount() {
        // Remove All Cache
        CacheManager.shared.removeAllData()
        // Remove All Cached Images
        ImageCache.shared.removeAllImages()
        // Logout
        AppConfiguration.authVC()
    }
}


// MARK: - Extensions -

extension ProfileVC: ProfileControlElementsDelegate {
    func clear() {
        clearCache()
    }
    
    func logout() {
        leaveFromAccount()
    }
}


// MARK: - UITableView Delegate and Data Source -

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
        
    // MARK: - Number of Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
        
    // MARK: - Cell Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Cell Data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTVCell.cellIdentifier, for: indexPath) as? ProfileImageTVCell else { return UITableViewCell() }
            
            cell.configureCell(model)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAdditionalInfoTVCell.cellIdentifier, for: indexPath) as? ProfileAdditionalInfoTVCell else { return UITableViewCell() }
            
            cell.configureCell(model)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileControlElementsTVCell.cellIdentifier, for: indexPath) as? ProfileControlElementsTVCell else { return UITableViewCell() }
            
            cell.configureCell(self)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
