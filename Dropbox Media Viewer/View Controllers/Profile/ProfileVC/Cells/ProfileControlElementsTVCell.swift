//
//  ProfileControlElementsTVCell.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 04.09.2023.
//

import UIKit

protocol ProfileControlElementsDelegate: AnyObject {
    func clear()
    func logout()
}

class ProfileControlElementsTVCell: BaseTVCell {
    
    
    // MARK: - IBOutlets -
    
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!

    
    // MARK: - Properties -
    
    private weak var delegate: ProfileControlElementsDelegate?
    
    
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
    
    func configureCell(_ delegate: ProfileControlElementsDelegate?) {
        self.delegate = delegate
    }
    
    
    // MARK: - IBActions Methods -
    
    @IBAction private func clearAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        sender.bounce()
        //
        delegate.clear()
    }
    
    @IBAction private func logoutAction(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        sender.bounce()
        //
        delegate.logout()
    }
}
