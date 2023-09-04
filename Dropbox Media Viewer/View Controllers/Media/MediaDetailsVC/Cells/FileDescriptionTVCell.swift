//
//  FileDescriptionTVCell.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 01.09.2023.
//

import UIKit

class FileDescriptionTVCell: BaseTVCell {
    
    
    // MARK: - IBOutlets -
    
    // Views
    @IBOutlet private weak var bodyView: UIView!
    
    // Labels
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var modifiedLabel: UILabel!
    
    
    // MARK: - Properties -
    
    private var mediaFile: MediaFile?

    
    // MARK: - Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override class var cellIdentifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Public Methods -
    
    func configureCell(_ mediaFile: MediaFile?) {
        self.mediaFile = mediaFile
        //
        configureUI()
    }
    
    
    // MARK: - Private Methods -
    
    private func configureUI() {
        guard let mediaFile = mediaFile else { return }
        
        nameLabel.text = mediaFile.name
        sizeLabel.text = mediaFile.size.fileSizeString()
        modifiedLabel.text = "Modified: " + mediaFile.modified.formattedModifiedDate()
    }
}
