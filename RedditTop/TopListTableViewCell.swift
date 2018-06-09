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
    
    private func setupCell() {
        imgThumbnail.contentMode = .scaleAspectFill
        imgThumbnail.layer.cornerRadius = 5
        imgThumbnail.clipsToBounds = true
        imgThumbnail.backgroundColor = .red
    }

    public func configureCell(title: String) {
        lblTitle.text = title
        lblDate.text = "3 hours ago"
        lblAuthor.text = "Joshua"
        lblNumComments.text = "14564 comments"
    }
    
}
