//
//  MediaDetailsVC.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import UIKit

class MediaDetailsVC: BaseVC {
    
    // MARK: - IBOutlets -
    
    // MARK: - Properties -
    
    private var mediaFile: MediaFile?

    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupTableView()                
    }
    
    // MARK: - Methods -
    
    func configureVC(_ file: MediaFile?) {
        mediaFile = file
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Cells
        FileDetailsTVCell.registerForTableView(aTableView: tableView)
        FileDescriptionTVCell.registerForTableView(aTableView: tableView)
        
        // Reload Data
        tableView.reloadData()
    }
    
    
    // MARK: - API Methods -
    
    private func getVideoFile(_ path: String, comlpetion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            
            APIManager.getVideoFile(withPath: path) { image, videoURL in
                if let image = image {
                    // Update UI
                    DispatchQueue.main.async {
                        // Save In Cache
                        ImageCache.shared.setImage(image, forKey: path)
                        // Update Model
                        strongSelf.mediaFile?.image = image
                        strongSelf.mediaFile?.videoURL = videoURL
                        // Update By Notification Center
                        NotificationCenter.default.post(name: .updateModel, object: nil, userInfo: ["model": strongSelf.mediaFile])
                        //
                        comlpetion()
                    }
                } else {
                    comlpetion()
                }
            }
        }
    }   
}


// MARK: - Extensions -

extension MediaDetailsVC: FileDetailsDelegate {
    func startVideoDownload(withPath path: String) {
        
        getVideoFile(path) {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableView Delegate and Data Source -

extension MediaDetailsVC: UITableViewDelegate, UITableViewDataSource {
        
    // MARK: - Number of Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
            
        default:
            return 0
        }
    }
        
    // MARK: - Cell Height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let currentImage = mediaFile?.image
            let imageRatio = currentImage?.getImageRatio()
            
            if let imageRatio = imageRatio {
                return tableView.frame.width / imageRatio
            } else {
                // Default Light Grey Placeholder
                return 332.0
            }
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    // MARK: - Cell Data
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FileDetailsTVCell.cellIdentifier, for: indexPath) as? FileDetailsTVCell else { return UITableViewCell() }
            
            cell.configureCell(mediaFile, delegate: self)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FileDescriptionTVCell.cellIdentifier, for: indexPath) as? FileDescriptionTVCell else { return UITableViewCell() }
                
            cell.configureCell(mediaFile)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
