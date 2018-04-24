//
//  RSSFeedViewModel.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class RSSFeedViewModel: NSObject {
    
    let parser: RSSFeedParser
    var feed: RSSFeed?
    //var query: String
    
    var didFailParsing: ((Error) -> ())?
    var didFinishParsing: (() -> ())?
    
    override init() {
        parser = RSSFeedParser()
       // query = ""
        
        super.init()
        
        configure()
    }
    
    private func configure() {
        parser.didFailParsing = { [weak self] error in
            self?.didFailParsing?(error)
        }
        
        parser.didFinishParsing = { [weak self] feed in
            self?.feed = feed
            self?.didFinishParsing?()
        }
    }
    
    func performSearch(withQuery query: String) {
        if let url = URL(string: query) {
            parser.parse(url: url)
        }
        
//        if let link = parser.filterRSSLink(fromUrl: query), let url = URL(string: link) {
//
//        }
    }
}

extension RSSFeedViewModel: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch(withQuery: searchBar.text!)
    }
}
