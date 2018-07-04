//
//  TopicsDataSource.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 02.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TopicsDataSource: NSObject {
    
    //MARK: - Properties
    
    var items = [FeedItem]()
    
}

//MARK: - UITableViewDataSource methods

extension TopicsDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        
        cell.item = items[indexPath.row]
        
        return cell
    }

}
