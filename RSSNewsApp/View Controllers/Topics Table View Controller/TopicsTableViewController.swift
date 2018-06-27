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

    var parcedData: [Dictionary<String, String>] = []

    //MARK: -

    let rssResources: [RSSResource] = [
        RSSResource(url: URL(string: "https://lifehacker.com/rss")!, channelTitle: "Lifehacker"),
        RSSResource(url: URL(string: "http://feeds.feedburner.com/TechCrunch/")!, channelTitle: "TechCrunch")
    ]
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .utility).async {
            for resource in self.rssResources {
                let rssParcer = RSSParser(resource: resource)
                rssParcer.delegate = self
                rssParcer.startParsing()
            }
        }
        
    }

    //MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath)
        let currentData = parcedData[indexPath.row]
        cell.textLabel?.text = currentData["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = parcedData[indexPath.row]["link"]
        let url = URL(string: link!)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    

}

//MARK: - RSSParserDelegate methods

extension TopicsTableViewController: RSSParserDelegate {

    func parsingWasFinished(_ parcer: RSSParser) {
        parcedData += parcer.parcedData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
