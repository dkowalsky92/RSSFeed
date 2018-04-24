//
//  RSSFeed.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class RSSFeed: NSObject {
    var channels: [RSSFeedChannel] = []
}

class RSSFeedChannel: NSObject {
    var title: String?
    var channelDescription: String?
    var link: String?
    var date: Date?
    var items: [RSSFeedItem] = []
}

class RSSFeedItem: NSObject {
    var title: String?
    var itemDescription: String?
    var link: String?
    var date: Date?
}


