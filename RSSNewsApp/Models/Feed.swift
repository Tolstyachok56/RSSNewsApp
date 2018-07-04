//
//  Feed.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 27.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class Feed {
    
    //MARK: - Properties
    
    let url: URL
    let channelTitle: String
    let pubDateFormat: String
    
    //MARK: - Initialization
    
    init(url: URL, channelTitle: String, pubDateFormat: String) {
        self.url = url
        self.channelTitle = channelTitle
        self.pubDateFormat = pubDateFormat
    }
    
}
