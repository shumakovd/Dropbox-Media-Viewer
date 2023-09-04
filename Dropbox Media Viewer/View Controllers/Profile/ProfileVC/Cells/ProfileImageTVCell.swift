//
//  ProfileImageTVCell.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 04.09.2023.
//

import UIKit

class ProfileImageTVCell: BaseTVCell {
    
    
    // MARK: - IBOutlets -
    
    // Image Views
    @IBOutlet private weak var profileImageView: UIImageView!
            
    // Activity Indicator
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    
    // MARK: - Properties -
    
    private var model: UserML?
    
    
    // MARK: - Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //
        model = nil
    }
    
    override class var cellIdentifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    
    // MARK: - Public Methods -
    
    func configureCell(_ model: UserML?) {
        self.model = model
        //
        configureUI()
    }
    
    
    // MARK: - Private Methods -
    
    private func configureUI() {
        guard let model = model else { return }
        
        activityIndicator.startAnimating()
        
        if let imageURL = model.photoURL {
            if let cachedImage = ImageCache.shared.image(forKey: imageURL) {
                activityIndicator.stopAnimating()
                profileImageView.image = cachedImage
            } else {
                downloadImage(from: imageURL)
            }
        }
    }
    
    private func downloadImage(from imageURL: String) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            guard let url = URL(string: imageURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                
                strongSelf.activityIndicator.stopAnimating()
                return
            }
            
            // Cache
            ImageCache.shared.setImage(image, forKey: imageURL)

            DispatchQueue.main.async {
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.profileImageView.image = image
            }
        }
    }
}
