//
//  FavoriteTopicsDataSource.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 04.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class FavoriteTopicsDataSource: NSObject {
    
    //MARK: - Properties
    
    var items = [FavoriteItem]()
    
}

//MARK: - UITableViewDataSource methods

extension FavoriteTopicsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        
        let item = items[indexPath.row]
        
        cell.topicLabel.text = item.title
        
        cell.topicImageView.image = UIImage(named: "imagePlaceholder")
        if let imageURL = item.imageURL {
            cell.topicImageView.setImage(from: imageURL as! URL, withPlaceholder: UIImage(named: "imagePlaceholder"))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.pubDateLabel.text = dateFormatter.string(from: (item.pubDate)!)
        
        cell.favoriteLabel.isHidden = false
        
        return cell
    }
    
}
