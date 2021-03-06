//
//  FeedItem.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 28.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class FeedItem {
    
    //MARK: - Properties
    
    var feed: Feed
    
    //MARK: -
    
    var title: String?
    var link: String?
    var pubDateString: String?
    var description: String?
    var guid: String?
    
    var isFavorite: Bool = false
    
    //MARK: -
    
    var pubDate: Date? {
        guard let dateString = pubDateString else { return nil }
        
        var pubDate: Date? = nil
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.feed.pubDateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        pubDate = dateFormatter.date(from: dateString)
        
        return pubDate
    }
    
    //MARK: -
    
    var imageLink: String? {
        guard let description = description as NSString? else { return nil }
        
        let rangeOfString = NSMakeRange(0, description.length)
        var imageLink: String? = nil
        
        do {
            let regex = try NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [])
            if description.length > 0 {
                guard let match = regex.firstMatch(in: description as String, options: [], range: rangeOfString) else { return nil }
                imageLink = description.substring(with: match.range(at: 2))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return imageLink
    }
    
    //MARK: - Initialization
    
    init(feed: Feed, title: String?, link: String?, pubDateString: String?, description: String?, guid: String?) {
        self.feed = feed
        self.title = title
        self.link = link
        self.pubDateString = pubDateString
        self.description = description
        self.guid = guid
    }
    
    convenience init(feed: Feed, dictionary: Dictionary<String, String>) {
        self.init(feed: feed,
                  title: dictionary["title"],
                  link: dictionary["link"],
                  pubDateString: dictionary["pubDate"],
                  description: dictionary["description"],
                  guid: dictionary["guid"]
        )
    }
    
}
