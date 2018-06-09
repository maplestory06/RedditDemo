//
//  TopListTableViewCell.swift
//  RedditTop
//
//  Created by Yue Shen on 6/9/18.
//  Copyright © 2018 Yue Shen. All rights reserved.
//

import UIKit

protocol TopListCellDelegate: class {
    func openURL(url: String)
}

class TopListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNumComments: UILabel!
    
    weak var delegate: TopListCellDelegate?
    private var imgURL = ""
    
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
        imgThumbnail.backgroundColor = .white
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imgThumbnail.addGestureRecognizer(tapGes)
    }

    public func configureCell(feed: RedditFeed) {
        lblTitle.text = feed.title
        lblDate.text = feed.created_utc.formatDate()
        lblAuthor.text = "by " + feed.author
        lblNumComments.text = feed.num_comments > 0 ? "\(feed.num_comments) comments" : "0 comment"
        
        imgURL = feed.thumbnail
        fetchImage(feed.thumbnail)
    }
    
    private func fetchImage(_ url: String) {
        Downloader.shared.imageFetch(with: url) { (image, message) in
            guard let img = image else {
                DispatchQueue.main.async {
                    self.imgThumbnail.isUserInteractionEnabled = false
                }
                return
            }
            DispatchQueue.main.async {
                self.imgThumbnail.image = img
                self.imgThumbnail.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc private func handleTap() {
        delegate?.openURL(url: self.imgURL)
    }
    
}
