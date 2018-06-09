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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchData()
    }

    private func setupTable() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsSelection = false
    }
    
    private func fetchData() {
        Downloader.shared.feedFetch { (feeds, message) in
            guard let data = feeds else {
                return
            }
            DispatchQueue.main.async {
                self.redditFeeds += data
                self.tableView.reloadData()
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
    
}

