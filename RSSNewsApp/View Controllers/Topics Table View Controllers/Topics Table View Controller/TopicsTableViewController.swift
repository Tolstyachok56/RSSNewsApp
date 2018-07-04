//
//  TopicsTableViewController.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 27.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController {
    
    //MARK: - Segue
    
    private enum Segue {
        static let Item = "Item"
    }
    
    //MARK: - Feeds list
    
    private let feeds: [Feed] = [
        Feed(url: URL(string: "https://lifehacker.com/rss")!, channelTitle: "Lifehacker", pubDateFormat: "EEE, d MMM yyyy HH:mm:ss zzz"),
        Feed(url: URL(string: "http://feeds.feedburner.com/TechCrunch/")!, channelTitle: "TechCrunch", pubDateFormat: "EEE, dd MMM yyyy HH:mm:ss Z")
    ]
    
    //MARK: - Properties
    
    var parsedData = ParsedData()
    
    private var parsedFeedsCount = 0
    
    //MARK: -
    
    private var topicsDataSource = TopicsDataSource()
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        tableView.dataSource = topicsDataSource
        parseFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    //MARK: - Data source methods
    
    private func setupDataSource() {
        let tabBarViewControllers = self.tabBarController?.viewControllers
        let favoriteNavigationVC = tabBarViewControllers![1] as! UINavigationController
        let favoriteVC = favoriteNavigationVC.viewControllers[0] as! FavoritesTableViewController
        favoriteVC.parsedData = self.parsedData
    }
    

    //MARK: - Parsing
    
    private func parseFeeds() {
        parsedData.items = []
        for feed in self.feeds {
            DispatchQueue.global(qos: .utility).async {
                let feedParcer = FeedParser(feed: feed)
                feedParcer.delegate = self
                feedParcer.startParsing()
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.Item:
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

//MARK: - RSSParserDelegate methods

extension TopicsTableViewController: FeedParserDelegate {
    
    func itemParsingWasFinished(_ parser: FeedParser, item: FeedItem) {
        Thread.sleep(forTimeInterval: 0.1)
        
        DispatchQueue.main.async {
            let indexPath = self.indexPathInParsedData(of: item)
            
            self.parsedData.items.insert(item, at: indexPath.row)
            self.topicsDataSource.items = self.parsedData.items
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }

    func parsingWasFinished(_ parser: FeedParser) {
        print("Parsing \(parser.feed.channelTitle) was finished.")
        parsedFeedsCount += 1
        
        if parsedFeedsCount == feeds.count {
            print("Parsing was finished.")
            
            //do something that has to be done after all feeds've been parsed
            
            parsedFeedsCount = 0
        }
    }
    
    //MARK: -  Helper methods
    
    private func indexPathInParsedData(of item: FeedItem) -> IndexPath {
        
        var i = 0
        
        if !self.parsedData.items.isEmpty {
            var x = self.parsedData.items[0]
            while item.pubDate! < x.pubDate! {
                i += 1
                if i < self.parsedData.items.count {
                    x = self.parsedData.items[i]
                } else {
                    break
                }
            }
        }
        
        return IndexPath(row: i, section: 0)
    }

}
