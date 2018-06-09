//
//  TopListTableViewCell.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

class TopListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNumComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgThumbnail.image = nil
    }
    
    private func setupCell() {
        imgThumbnail.contentMode = .scaleAspectFill
        imgThumbnail.layer.cornerRadius = 5
        imgThumbnail.clipsToBounds = true
        imgThumbnail.backgroundColor = .lightGray
    }

    public func configureCell(feed: RedditFeed) {
        lblTitle.text = feed.title
        lblDate.text = feed.created_utc
        lblAuthor.text = "by" + feed.author
        lblNumComments.text = feed.num_comments > 0 ? "\(feed.num_comments) comments" : "0 comment"
        fetchImage(feed.thumbnail)
    }
    
    private func fetchImage(_ url: String) {
        Downloader.shared.imageFetch(with: url) { (image, message) in
            DispatchQueue.main.async {
                self.imgThumbnail.image = image
            }
        }
    }
    
}
