//
//  RedditFeed.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import Foundation

struct RedditFeed {
    
    var title: String
    var author: String
    var thumbnail: String
    var created_utc: Double
    var num_comments: Int
    
    init(dict: [String: Any]) {
        if let t = dict["title"] as? String {
            self.title = t
        } else {
            self.title = ""
        }
        if let a = dict["author"] as? String {
            self.author = a
        } else {
            self.author = ""
        }
        if let nail = dict["thumbnail"] as? String {
            self.thumbnail = nail
        } else {
            self.thumbnail = ""
        }
        if let time = dict["created_utc"] as? Double {
            self.created_utc = time
        } else {
            self.created_utc = 0
        }
        if let num = dict["num_comments"] as? Int {
            self.num_comments = num
        } else {
            self.num_comments = 0
        }
    }
    
}
