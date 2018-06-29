//
//  FeedParser.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 27.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

protocol FeedParserDelegate {
    func parsingWasFinished(_ parser: FeedParser)
    
    func itemParsingWasFinished(_ parser: FeedParser, item: FeedItem)
}

class FeedParser: NSObject {
    
    //MARK: - Properties
    
    var parsedData = [FeedItem]()
    private var currentData = Dictionary<String, String>()
    private var currentElement = ""
    private var foundCharacters = ""
    
    //MARK: -
    
    var delegate: FeedParserDelegate?
    
    //MARK: -
    
    var feed: Feed!
    
    var feeds: [Feed]
    
    var parsingCount: Int = 0
    
    //MARK: - Initialization
    
//    init(feed: Feed) {
//        self.feed = feed
//        super.init()
//    }
    
    init?(feeds: [Feed]) {
        if feeds.isEmpty {
            return nil
        } else {
            self.feeds = feeds
            super.init()
            
        }
    }
    
    //MARK: - Methods
    
    func startParsing() {
//        let parcer = XMLParser(contentsOf: self.feed.url)
//        parcer?.delegate = self
//        parcer?.parse()
        for feed in feeds {
            self.feed = feed
            let parser = XMLParser(contentsOf: feed.url)
            parser?.delegate = self
            parser?.parse()
        }
    }
    
}

//MARK: - XMLParserDelegate methods

extension FeedParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "title" && string != feed?.channelTitle) || currentElement == "link" || currentElement == "pubDate" || currentElement == "description" {
            foundCharacters += string
        } else {
            foundCharacters = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            if elementName == "link" {
                foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            currentData[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if currentData.count == 4 {
                let feedItem = FeedItem(feed: feed!, dictionary: currentData)
                parsedData.append(feedItem)
                delegate?.itemParsingWasFinished(self, item: feedItem)
                currentData = [:]
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parsingCount += 1
        if parsingCount == feeds.count {
            parsedData.sort { $0.pubDate!.compare($1.pubDate!) == .orderedDescending }
            self.delegate?.parsingWasFinished(self)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.localizedDescription)
    }
    
}

