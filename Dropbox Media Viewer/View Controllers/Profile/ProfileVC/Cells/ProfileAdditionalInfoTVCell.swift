//
//  ProfileAdditionalInfoTVCell.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 04.09.2023.
//

import UIKit

class ProfileAdditionalInfoTVCell: BaseTVCell {
    
    
    // MARK: - IBOutlets -
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!

    
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
        
        nameLabel.text = model.name
        emailLabel.text = model.email
    }
}
