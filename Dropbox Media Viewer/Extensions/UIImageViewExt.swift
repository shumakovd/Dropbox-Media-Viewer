//
//  UIImageViewExt.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 30.08.2023.
//

import UIKit
import Kingfisher

// FIXME: - Not used in this project

extension UIImageView {
    
    // MARK: - Kingfisher
    
    func setImage(url: String?) {
        let imageUrl = URL(string: url ?? "")
        let processor = ResizingImageProcessor(referenceSize: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], completionHandler: {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            })
    }
}
