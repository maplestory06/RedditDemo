//
//  RedditFeed.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import Foundation

class RedditFeed: NSObject, NSCoding {
    
    var title: String = ""
    var author: String = ""
    var thumbnail: String = ""
    var created_utc: Double = 0
    var num_comments: Int = 0
    var url: String = ""
    
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
        if let url = dict["url"] as? String {
            self.url = url
        } else {
            self.url = ""
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.author, forKey: "author")
        aCoder.encode(self.thumbnail, forKey: "thumbnail")
        aCoder.encode(self.created_utc, forKey: "created_utc")
        aCoder.encode(self.num_comments, forKey: "num_comments")
        aCoder.encode(self.url, forKey: "url")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        }
        if let author = aDecoder.decodeObject(forKey: "author") as? String {
            self.author = author
        }
        if let thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String {
            self.thumbnail = thumbnail
        }
        self.created_utc = aDecoder.decodeDouble(forKey: "created_utc")
        self.num_comments = aDecoder.decodeInteger(forKey: "num_comments")
        if let url = aDecoder.decodeObject(forKey: "url") as? String {
            self.url = url
        }
    }
}
