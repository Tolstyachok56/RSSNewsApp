//
//  FavoritesTableViewController.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 04.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    // MARK: - Segue
    
    private enum Segue {
        static let FavoriteItem = "FavoriteItem"
    }
    
    // MARK: - Properties
    
    var parsedData: ParsedData?
    
    // MARK: -
    
    var topicDataSource = TopicsDataSource()
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataSource()
        tableView.dataSource = topicDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDataSource()
        tableView.reloadData()
    }
    
    // MARK: - Data source methods
    
    private func updateDataSource() {
        topicDataSource.items = (parsedData?.favoriteItems)!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.FavoriteItem:
            guard let destination = segue.destination as? TopicViewController else { return }
            guard let cell = sender as? TopicTableViewCell else { return }
            destination.item = cell.item
        default:
            fatalError("Unexpected segue identifier")
        }
    }
    
    //MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
