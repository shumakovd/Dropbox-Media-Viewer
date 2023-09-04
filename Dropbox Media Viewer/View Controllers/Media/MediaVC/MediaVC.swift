//
//  MediaVC.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit

class MediaVC: BaseVC {
    
    
    // MARK: - Properties -
    
    private var mediaFiles: [MediaFile] = []
    private var allMediaFilesAreDonwloaded: Bool = true
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupTableView()
        fetchMediaFiles()
    }
    
    deinit {
        // Remove Notifications
        removeNotifications()
    }
    
    
    // MARK: - Methods -
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cells
        MediaPreviewTVCell.registerForTableView(aTableView: tableView)
        
        // Content Inset
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
    }      
    
    
    // MARK: - API Methods -
        
    private func fetchMediaFiles() {
        APIManager.fetchMediaFilesForFirstTime { [weak self] result in
            guard let strongSelf = self else { return }
            // Append Result
            strongSelf.mediaFiles = result
            // Reload Data
            strongSelf.tableView.reloadData()
            // Now user can donwload more
            strongSelf.allMediaFilesAreDonwloaded = false
        }
    }
    
    private func fetchMoreMediaFiles() {
        APIManager.fetchMoreMediaFiles { [weak self] result, canUsersDownloadMore in
            guard let strongSelf = self else { return }
            // Append Result
            strongSelf.mediaFiles.append(contentsOf: result)
            // Reload Data
            strongSelf.tableView.reloadData()
            // Now user can donwload more
            strongSelf.allMediaFilesAreDonwloaded = canUsersDownloadMore
        }
    }
        
        
    // MARK: - Overrided Methods
    
    override func listenNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(updateModel),
                                       name: .updateModel,
                                       object: nil)
    }
    
    
    @objc private func updateModel(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let model = userInfo["model"] as? MediaFile else { return }
        
        let count = mediaFiles.count
        for i in 0 ..< count {
            if mediaFiles[i].id == model.id {
                mediaFiles[i] = model
            }
        }
    }
    
    
    // MARK: - Navigation Methods -
    
    private func navigateToMediaDetails(_ file: MediaFile?) {
        let vc = kMediaStoryboard.instantiateViewController(withIdentifier: ViewControllerIDs.MediaStoryboard.kMediaDetailsVC) as! MediaDetailsVC
        vc.configureVC(file)
        show(vc, sender: nil)
    }    
}


// MARK: - Extensions -

extension MediaVC: MediaPreviewDelegate {
    func getSelectedMediaFileDetails(id: String) {
        var model: MediaFile?
        
        for each in mediaFiles {
            if each.id == id {
                model = each
            }
        }
        
        navigateToMediaDetails(model)
    }
}


// MARK: - UITableView Delegate and Data Source -

extension MediaVC: UITableViewDelegate, UITableViewDataSource {
        
    // MARK: - Number of Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaFiles.count
    }
        
    // MARK: - Cell Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Cell Data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaPreviewTVCell.cellIdentifier, for: indexPath) as? MediaPreviewTVCell else { return UITableViewCell() }
            
        cell.configureCell(mediaFiles[indexPath.row], delegate: self)
        return cell
    }
    
    // MARK: - Cell Display
    
    func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let mediaFilesCount: UInt = UInt(mediaFiles.count - 1)
        
        // print("• INDEXPATH.ROW: ", indexPath.row, mediaFilesCount, allMediaFilesAreDonwloaded)
        if indexPath.row == mediaFilesCount, allMediaFilesAreDonwloaded == false {
            fetchMoreMediaFiles()
        }
    }
}
