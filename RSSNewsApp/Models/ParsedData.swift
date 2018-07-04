//
//  ParsedData.swift
//  RSSNewsApp
//
//  Created by Виктория Бадисова on 04.07.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class ParsedData {
    
    // MARK: - Properties
    
    var items: [FeedItem] = []
    
    var favoriteItems: [FeedItem] {
        return items.filter { $0.isFavorite }
    }
    
}
