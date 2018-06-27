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
    
    
    
    //MARK: -
    
    let rssResources: [RSSResource] = [
        RSSResource(url: URL(string: "https://lifehacker.com/rss")!, channelTitle: "Lifehacker"),
        RSSResource(url: URL(string: "http://feeds.feedburner.com/TechCrunch/")!, channelTitle: "TechCrunch")
    ]
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
