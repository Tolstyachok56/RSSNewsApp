//
//  TopicTableViewCell.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 28.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
    
    //MARK: - Properties

    @IBOutlet var topicImageView: UIImageView!
    @IBOutlet var topicLabel: UILabel!
    @IBOutlet var pubDateLabel: UILabel!
    
    //MARK: - 
    
    var item: FeedItem? {
        didSet {
            
            //label
            self.topicLabel.text = item?.title
        
            //image
            self.topicImageView.image = UIImage(named: "imagePlaceholder")
            
            if let imageLink = item?.imageLink {
                let imageURL = URL(string: imageLink)
                self.topicImageView.setImage(from: imageURL!, withPlaceholder: UIImage(named: "imagePlaceholder"))
            }
            
            //pubDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            self.pubDateLabel.text = dateFormatter.string(from: (item?.pubDate)!)
            
        }
    }
    
    //MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
