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
    
    //MARK: - Properties
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    //MARK: -
    
    private let feeds: [Feed] = [
        Feed(url: URL(string: "https://lifehacker.com/rss")!, channelTitle: "Lifehacker", pubDateFormat: "EEE, d MMM yyyy HH:mm:ss zzz"),
        Feed(url: URL(string: "http://feeds.feedburner.com/TechCrunch/")!, channelTitle: "TechCrunch", pubDateFormat: "EEE, dd MMM yyyy HH:mm:ss Z")
    ]
    
    private var parsedFeedsCount = 0
    
    //MARK: -
    
    var parsedItems: [FeedItem] = []
    
    //MARK: -
    
    var topicsDataSource = TopicsDataSource()
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = topicsDataSource
        
        parseFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func dataSourceToggle(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        if index == 0 {
            topicsDataSource.items = parsedItems
        } else if index == 1 {
            let favoriteItems = parsedItems.filter { $0.isFavorite }
            topicsDataSource.items = favoriteItems
        }
        tableView.reloadData()
        if topicsDataSource.items.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    //MARK: - Parsing
    
    private func parseFeeds() {
        parsedItems = []
        segmentedControl.isEnabled = false
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
            
            self.parsedItems.insert(item, at: indexPath.row)
            self.topicsDataSource.items = self.parsedItems
            
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
            DispatchQueue.main.async {
                self.segmentedControl.isEnabled = true
            }
            parsedFeedsCount = 0
        }
    }
    
    //MARK: -  Helper methods
    
    private func indexPathInParsedData(of item: FeedItem) -> IndexPath {
        
        var i = 0
        
        if !self.parsedItems.isEmpty {
            var x = self.parsedItems[0]
            while item.pubDate! < x.pubDate! {
                i += 1
                if i < self.parsedItems.count {
                    x = self.parsedItems[i]
                } else {
                    break
                }
            }
        }
        
        return IndexPath(row: i, section: 0)
    }

}
