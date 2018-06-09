//
//  TopListViewController.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == redditFeeds.count - 1 {
            fetchData()
        }
    }
    
}

