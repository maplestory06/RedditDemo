//
//  Downloader.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import Foundation

class Downloader {
    
    static let shared = Downloader()
    
    func feedFetch(_ completion: @escaping ([RedditFeed]?, Any?) -> Void) {
        guard var components = URLComponents(string: "https://www.reddit.com/r/all/top.json") else {
            completion(nil, "No valid url components")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "after", value: Key.shared.pagination_after)
        ]
        guard let url = components.url else {
            completion(nil, "Not a valid url")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completion(nil, err)
            } else {
                guard let result = data else {
                    completion(nil, "No valid data")
                    return
                }
                var feeds = [RedditFeed]()
                do {
                    guard let json = try JSONSerialization.jsonObject(with: result, options: []) as? [String: Any] else {
                        completion(nil, "No valid json")
                        return
                    }
                    guard let data = json["data"] as? [String: Any] else {
                        completion(nil, "No valid json data")
                        return
                    }
                    // pagination purpose
                    if let after = data["after"] as? String {
                        Key.shared.pagination_after = after
                    }
                    guard let children = data["children"] as? [[String: Any]] else {
                        completion(nil, "No children")
                        return
                    }
                    print("count:", children.count)
                    for child in children {
                        guard let child_data = child["data"] as? [String: Any] else {
                            continue
                        }
                        let feed = RedditFeed(dict: child_data)
                        print(feed)
                        feeds.append(feed)
                    }
                    completion(feeds, nil)
                } catch {
                    
                }
            }
        }
        task.resume()
    }
    
}
