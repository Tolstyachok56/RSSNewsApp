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
    
    private let rssFeeds: [Feed] = [
        Feed(url: URL(string: "https://lifehacker.com/rss")!, channelTitle: "Lifehacker", pubDateFormat: "EEE, d MMM yyyy HH:mm:ss zzz")]/*,
        Feed(url: URL(string: "http://feeds.feedburner.com/TechCrunch/")!, channelTitle: "TechCrunch", pubDateFormat: "EEE, dd MMM yyyy HH:mm:ss Z")
    ]*/
    
    //MARK: -
    
    private var parsedData: [FeedItem] = []
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "RSSNewsApp"
        
        parseAllFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK: - Parsing
    
    private func parseAllFeeds() {
        parsedData = []
        for feed in self.rssFeeds {
            DispatchQueue.global(qos: .utility).async {
                let rssParcer = FeedParser(feed: feed)
                rssParcer.delegate = self
                rssParcer.startParsing()
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

    //MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("DataSource call: \(Date())")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as! TopicTableViewCell
        
        cell.item = parsedData[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - UITableViewDelegate methods
    
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
            print("Item process time: \(Date())")
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
        }
    }

    func parsingWasFinished(_ parser: FeedParser) {
        print("Parsing \(parser.feed.channelTitle) was finished.")
    }
    
    // Helper method
    
    private func indexPathInParsedData(of item: FeedItem) -> IndexPath {
        
        var i = 0
        
        if !self.parsedData.isEmpty {
            var x = self.parsedData[0]
            while item.pubDate! < x.pubDate! {
                i += 1
                if i < self.parsedData.count {
                    x = self.parsedData[i]
                } else {
                    break
                }
            }
        }
        
        self.parsedData.insert(item, at: i)
        
        return IndexPath(row: i, section: 0)
    }

}
