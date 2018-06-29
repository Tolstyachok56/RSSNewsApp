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
    
    //MARK: - Initialization
    
    init(feed: Feed) {
        self.feed = feed
        super.init()
    }
    
    //MARK: - Methods
    
    func startParsing() {
        let parcer = XMLParser(contentsOf: self.feed.url)
        parcer?.delegate = self
        parcer?.parse()
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
        self.delegate?.parsingWasFinished(self)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.localizedDescription)
    }
    
}

