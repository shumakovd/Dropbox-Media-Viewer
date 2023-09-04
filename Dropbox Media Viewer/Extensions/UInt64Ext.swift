//
//  UInt64Ext.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 01.09.2023.
//

import Foundation

extension UInt64 {
    func fileSizeString() -> String {
        let fileSizeInBytes = Double(self)
        
        // Byte
        if fileSizeInBytes < 1024.0 {
            return String(format: "%.0f B", fileSizeInBytes)
        
        // Лilobyte
        } else if fileSizeInBytes < 1048576.0 {
            let fileSizeInKB = fileSizeInBytes / 1024.0
            return String(format: "%.0f KB", fileSizeInKB)
        
        // Megabyte
        } else if fileSizeInBytes < 1073741824.0 {
            let fileSizeInMB = fileSizeInBytes / 1048576.0
            return String(format: "%.2f MB", fileSizeInMB)
            
        // Gigabyte
        } else {
            let fileSizeInGB = fileSizeInBytes / 1073741824.0
            return String(format: "%.2f GB", fileSizeInGB)
        }
    }
}
