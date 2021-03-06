//
//  TopListViewController.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit
import Photos

class TopListViewController: UITableViewController {

    private var redditFeeds = [RedditFeed]()
    private var refreshCtrl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        restoreData()
    }

    // MARK: - TableView Setup
    
    private func setupTable() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
        
        refreshCtrl = UIRefreshControl()
        tableView.addSubview(refreshCtrl)
        refreshCtrl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    // Restore data from last state
    // If fail to restore, then refresh the newest top 50 feeds
    private func restoreData() {
        if let archivedfeeds = UserDefaults.standard.object(forKey: "feeds") as? Data {
            let feeds = convert(data: archivedfeeds)
            guard feeds.count > 0 else {
                refreshData()
                return
            }
            self.redditFeeds = feeds
            self.tableView.reloadData()
        } else {
            refreshData()
        }
    }
    
    // Fetch data based on last pagination cursor
    private func fetchData() {
        Downloader.shared.feedFetch { (feeds, message) in
            guard let data = feeds else {
                return
            }
            DispatchQueue.main.async {
                self.redditFeeds += data
                let archievedData = self.convert(feeds: self.redditFeeds)
                UserDefaults.standard.set(archievedData, forKey: "feeds")
                self.tableView.reloadData()
            }
        }
    }
    
    // Pull to refresh the top 50 feeds from reddit
    @objc private func refreshData() {
        Downloader.shared.feedFetch(refresh: true) { (feeds, message) in
            guard let data = feeds else {
                return
            }
            DispatchQueue.main.async {
                self.redditFeeds = data
                let archievedData = self.convert(feeds: data)
                UserDefaults.standard.set(archievedData, forKey: "feeds")
                self.tableView.reloadData()
                self.refreshCtrl.endRefreshing()
            }
        }
    }
    
    // MARK: - TableView Delegate & Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditFeeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListTableViewCell", for: indexPath) as! TopListTableViewCell
        cell.configureCell(feed: redditFeeds[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == redditFeeds.count - 1 {
            fetchData()
        }
    }
    
}

extension TopListViewController: TopListCellDelegate {
    
    // MARK: - Cell image tapping control
    
    func openURL(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func saveImage(img: UIImage?) {
        guard let image = img else {
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.actionSheetSaveImage(image)
                } else {
                    
                }
            })
        } else if status == .authorized {
            actionSheetSaveImage(image)
        }
    }
    
    // Action sheet to let user choose save image or not
    func actionSheetSaveImage(_ img: UIImage) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Save Image", style: .default) { (_) in
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.action(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Notify if the image is saved successfully or not
    @objc func action(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            let alert = UIAlertController(title: "Fail to Save", message: "please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Auxilaries
    func convert(feeds: [RedditFeed]) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: feeds as Array)
        return data
    }
    
    func convert(data: Data) -> [RedditFeed] {
        if let data = NSKeyedUnarchiver.unarchiveObject(with: data) as? [RedditFeed] {
            return data
        }
        return []
    }
}

