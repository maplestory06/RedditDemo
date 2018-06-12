//
//  Downloader.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class Downloader {
    
    static let shared = Downloader()
    
    func feedFetch(refresh: Bool = false, _ completion: @escaping ([RedditFeed]?, Any?) -> Void) {
        guard var components = URLComponents(string: "https://www.reddit.com/r/all/top.json") else {
            completion(nil, "No valid url components")
            return
        }
        if refresh {
            components.queryItems = [
                URLQueryItem(name: "limit", value: "50")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "limit", value: "50"),
                URLQueryItem(name: "after", value: Key.shared.pagination_after)
            ]
        }
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
                        UserDefaults.standard.set(after, forKey: "pagination_after")
                    }
                    guard let children = data["children"] as? [[String: Any]] else {
                        completion(nil, "No children")
                        return
                    }
                    for child in children {
                        guard let child_data = child["data"] as? [String: Any] else {
                            continue
                        }
                        let feed = RedditFeed(dict: child_data)
                        feeds.append(feed)
                    }
                    completion(feeds, nil)
                } catch {
                    
                }
            }
        }
        task.resume()
    }
    
    func imageFetch(with url: String, _ completion: @escaping (UIImage?, Any?) -> Void) {
        if let imgFromCache = imageCache.object(forKey: url as NSString) {
            completion(imgFromCache, nil)
        } else {
            guard let realUrl = URL(string: url) else {
                completion(nil, "Not a valid url")
                return
            }
            let request = URLRequest(url: realUrl)
            let task = URLSession.shared.downloadTask(with: request, completionHandler: { (urlReq, response, error) in
                if let err = error {
                    completion(nil, err)
                } else {
                    if let req = urlReq {
                        if let data = try? Data(contentsOf: req) {
                            if let img = UIImage(data: data) {
                                imageCache.setObject(img, forKey: url as NSString)
                                completion(img, nil)
                            } else {
                                completion(nil, "No valid image")
                            }
                        } else {
                            completion(nil, "No valid data")
                        }
                    } else {
                        completion(nil, "No valid request")
                    }
                }
            })
            task.resume()
        }
    }
    
}
