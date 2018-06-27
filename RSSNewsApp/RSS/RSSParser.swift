//
//  RSSParser.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 27.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

protocol RSSParserDelegate {
    func parsingWasFinished(_ parcer: RSSParser)
}

class RSSParser: NSObject {
    
    //MARK: - Properties
    
    var parcedData = [Dictionary<String, String>]()
    private var currentData = Dictionary<String, String>()
    private var currentElement = ""
    private var foundCharacters = ""
    
    //MARK: -
    
    var delegate: RSSParserDelegate?
    
    //MARK: -
    
    var resource: RSSResource
    
    //MARK: - Initialization
    
    init(resource: RSSResource) {
        self.resource = resource
        super.init()
    }
    
    //MARK: - Methods
    
    func startParsing() {
        let parcer = XMLParser(contentsOf: resource.url)
        parcer?.delegate = self
        parcer?.parse()
    }
    
}

//MARK: - XMLParserDelegate methods

extension RSSParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElement == "title" && string != resource.channelTitle) || currentElement == "link" || currentElement == "pubDate" {
            foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            if elementName == "link" {
                foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            currentData[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if currentElement == "pubDate" {
                parcedData.append(currentData)
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

