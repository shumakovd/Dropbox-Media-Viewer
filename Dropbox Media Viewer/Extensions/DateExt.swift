//
//  DateExt.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 01.09.2023.
//

import Foundation

extension Date {
    func formattedModifiedDate() -> String {
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd.MM.yy"
        }
        
        return dateFormatter.string(from: self)
    }
}
