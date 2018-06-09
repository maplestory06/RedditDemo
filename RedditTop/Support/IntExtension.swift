//
//  IntExtension.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import Foundation

extension Double {
    
    func formatDate() -> String {
        let myDate = Date(timeIntervalSince1970: self)
        let localTimeZone = NSTimeZone.local.abbreviation()
        let elapsed = Int(Date().timeIntervalSince(myDate))
        if localTimeZone != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "\(localTimeZone!)")
            let normalFormat = dateFormatter.string(from: myDate)
            dateFormatter.dateFormat = "EEEE, HH:mm"
            let dayFormat = dateFormatter.string(from: myDate)
            // Greater than or equal to one day
            if elapsed >= 604800 {
                return "\(normalFormat)"
            } else if elapsed >= 172800 {
                return "\(dayFormat)"
            } else if elapsed >= 86400 {
                return "Yesterday"
            } else if elapsed >= 7200 {
                let hoursPast = Int(elapsed / 3600)
                return "\(hoursPast) hours ago"
            } else if elapsed >= 3600 {
                return "1 hour ago"
            } else if elapsed >= 120 {
                let minsPast = Int(elapsed / 60)
                return "\(minsPast) mins ago"
            } else if elapsed >= 60 {
                return "1 min ago"
            } else {
                return "Just Now"
            }
        } else {
            return "Invalid Date"
        }
    }
    
}
