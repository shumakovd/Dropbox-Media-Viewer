//
//  UIImageExt.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 03.09.2023.
//

import UIKit

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
