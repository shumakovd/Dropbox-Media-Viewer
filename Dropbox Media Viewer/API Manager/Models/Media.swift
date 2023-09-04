//
//  Media.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 30.08.2023.
//

import UIKit

enum MediaType {
    case photo
    case video
}

struct MediaFile {
    let id: String
    
    let name: String
    let size: UInt64
    let path: String?
    
    let modified: Date
    
    var image: UIImage?
    var videoURL: URL?
    
    let mediaType: MediaType
}
