//
//  TopicsTableViewController.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 27.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    let rssFeeds: [Feed] = [
        Feed(url: URL(string: "https://lifehacker.com/rss")!, channelTitle: "Lifehacker", pubDateFormat: "EEE, d MMM yyyy HH:mm:ss zzz"),
        Feed(url: URL(string: "http://feeds.feedburner.com/TechCrunch/")!, channelTitle: "TechCrunch", pubDateFormat: "EEE, d MMM yyyy HH:mm:ss Z")
    ]
    
    var parsedData: [FeedItem] = []
    
    var sortedParsedData: [FeedItem] {
        return parsedData//.sorted { $0.pubDate!.compare($1.pubDate!) == .orderedDescending }
    }
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RSSNewsApp"
//        for feed in self.rssFeeds {
//            DispatchQueue.global(qos: .utility).async {
//                let rssParcer = FeedParser(feed: feed)
//                rssParcer.delegate = self
//                rssParcer.startParsing()
//            }
//        }
        DispatchQueue.global(qos: .utility).async {
            let rssParser = FeedParser(feeds: self.rssFeeds)
            rssParser?.delegate = self
            rssParser?.startParsing()
        }
        
    }

    //MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedParsedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        
        cell.item = sortedParsedData[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentData = sortedParsedData[indexPath.row]
        let url = URL(string: currentData.link!)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }

}

//MARK: - RSSParserDelegate methods

extension TopicsTableViewController: FeedParserDelegate {
    
    func itemParsingWasFinished(_ parser: FeedParser, item: FeedItem) {
//        DispatchQueue.main.async {
//            self.parsedData.append(item)
//            self.tableView.beginUpdates()
//            self.tableView.insertRows(at: [IndexPath(row: self.parsedData.count - 1, section: 0)], with: .automatic)
//            self.tableView.endUpdates()
//        }
    }

    func parsingWasFinished(_ parser: FeedParser) {
        print("Parsing \(parser.feed.channelTitle) was finished.")
        DispatchQueue.main.async {
            self.parsedData += parser.parsedData
            self.tableView.reloadData()
        }
    }

}
