//
//  RSSResource.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 27.06.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class RSSResource {
    
    let url: URL
    let channelTitle: String
    
    init(url: URL, channelTitle: String) {
        self.url = url
        self.channelTitle = channelTitle
    }
    
}
