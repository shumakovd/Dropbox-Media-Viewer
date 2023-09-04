//
//  MediaPreviewTVCell.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 30.08.2023.
//

import UIKit

protocol MediaPreviewDelegate: AnyObject {
    func getSelectedMediaFileDetails(id: String)
}

class MediaPreviewTVCell: BaseTVCell {
    
    
    // MARK: - IBOutlets -
    
    // Views
    @IBOutlet private weak var bodyView: UIView!
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var videoMarkImageView: UIImageView!
    
    // Labels
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    
    // Button
    @IBOutlet private weak var selectButton: UIButton!
    
    // Activity Indicator
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties -

    private var loading: Bool = false
    private var mediaFile: MediaFile? = nil
    private weak var delegate: MediaPreviewDelegate?
            
    
    // MARK: - Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //
        mediaFile = nil
        previewImageView.image = nil
    }
    
    override class var cellIdentifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Public Methods -
    
    func configureCell(_ mediaFile: MediaFile?, delegate: MediaPreviewDelegate?) {
        self.mediaFile = mediaFile
        self.delegate = delegate
        //
        configureUI()
    }
    
    
    // MARK: - Private Methods -
    
    private func configureUI() {
        guard let mediaFile = mediaFile else { return }
        
        nameLabel.text = mediaFile.name
        sizeLabel.text = mediaFile.size.fileSizeString()
        
        switch mediaFile.mediaType {
        case .photo:
            configureUIForImageMedia(mediaFile.path ?? "")
            
        case .video:
            configureUIForVideoMedia(mediaFile.path ?? "")
        }
    }
    
    private func configureUIForImageMedia(_ path: String) {
        // Get From Cache
        if let cachedImage = ImageCache.shared.image(forKey: path) {
            
            mediaFile?.image = cachedImage
            activityIndicator.stopAnimating()
            previewImageView.image = cachedImage
            
            // Update By Notification Center
            NotificationCenter.default.post(name: .updateModel, object: nil, userInfo: ["model": mediaFile])
            
        } else if previewImageView.image == nil, loading == false {            
            loading = true
            // Start Activity Indicator
            activityIndicator.startAnimating()
                        
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let strongSelf = self else { return }

                APIManager.getImageFile(withPath: path) { image in
                    if let image = image {
                        // Update UI
                        DispatchQueue.main.async {
                            if strongSelf.previewImageView.image == nil, path == strongSelf.mediaFile?.path {
                                // Set Image
                                strongSelf.previewImageView.image = image
                                // Save In Cache
                                ImageCache.shared.setImage(image, forKey: path)
                                // Update Model
                                strongSelf.mediaFile?.image = image
                                // Update By Notification Center
                                NotificationCenter.default.post(name: .updateModel, object: nil, userInfo: ["model": strongSelf.mediaFile])
                            }
                            //
                            strongSelf.loading = false
                            strongSelf.selectButton.isEnabled = true
                            //
                            strongSelf.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    private func configureUIForVideoMedia(_ path: String) {
        
        activityIndicator.startAnimating()
        
        if let cachedImage = ImageCache.shared.image(forKey: path) {
            
            mediaFile?.image = cachedImage
            activityIndicator.stopAnimating()
                        
            previewImageView.image = cachedImage
            videoMarkImageView.isHidden = false
            
            // Update By Notification Center
            NotificationCenter.default.post(name: .updateModel, object: nil, userInfo: ["model": mediaFile])
            
        } else {
            // Stop Indicator
            activityIndicator.stopAnimating()
            videoMarkImageView.isHidden = false
        }
    }
              

    // MARK: - IBActions -
    
    @IBAction private func mediafileSelectedAction(_ sender: UIButton) {
        guard let mediaFile = mediaFile else { return }
        bodyView.viewAnimationTouch() {
            self.delegate?.getSelectedMediaFileDetails(id: mediaFile.id)
        }
    }
}
