//
//  RSSFeedParser.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class RSSFeedParser: NSObject {
    
    final let dateFormat = "E, d MMM yyyy HH:mm:ss Z"
    
    private var rssFeed: RSSFeed!
    
    private var parser: XMLParser!
    private var parent: String?
    private var value: String?
    private var currentCharacterValue: String!
    private var properties: [String : Any]?
    
    
    var didFinishParsing: ((RSSFeed) -> ())?
    var didFailParsing: ((Error) -> ())?
    
    override init() {
        currentCharacterValue = ""
        super.init()
    }
    
    private func convertToHTML(_ url: String) -> String? {
        if let url = URL(string: url) {
            if let contents = try? String(contentsOf: url) {
                return contents
            }
        }
        return nil
    }
    
    func filterRSSLink(fromUrl url: String) -> String? {
        if let htmlContent = convertToHTML(url) {
            let results = htmlContent.matches(for: "\\<link.*application\\/rss\\+xml.*\\>")
            if results.count > 0 {
                let links = results[0].matches(for: "href=\".*\"")
                if links.count > 0 {
                    return links[0].components(separatedBy: CharacterSet.init(charactersIn: "\""))[1]
                }
            }
        }
        
        return nil
    }
    
    func parse(url: URL) {
        parser = XMLParser(contentsOf: url)
        parser.delegate = self
        parser.parse()
    }
}

extension RSSFeedParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        rssFeed = RSSFeed()
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        didFinishParsing?(rssFeed)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "channel":
            parent = elementName
            rssFeed.channels.append(RSSFeedChannel())
        case "item":
            parent = elementName
            rssFeed.channels.last?.items.append(RSSFeedItem())
        default:
            value = elementName
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch parent {
        case "channel":
            switch value {
            case "title": rssFeed.channels.last?.title = currentCharacterValue
            case "description": rssFeed.channels.last?.channelDescription = currentCharacterValue
            case "link": rssFeed.channels.last?.link = currentCharacterValue
            case "pubDate": rssFeed.channels.last?.date = currentCharacterValue?.toDate(withFormat: dateFormat)
            default: break
            }
        case "item":
            switch value {
            case "title": rssFeed.channels.last?.items.last?.title = currentCharacterValue
            case "description": rssFeed.channels.last?.items.last?.itemDescription = currentCharacterValue
            case "link": rssFeed.channels.last?.items.last?.link = currentCharacterValue
            case "pubDate": rssFeed.channels.last?.items.last?.date = currentCharacterValue?.toDate(withFormat: dateFormat)
            default: break
            }
        default:
            break
        }
        currentCharacterValue = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentCharacterValue = currentCharacterValue + string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        didFailParsing?(parseError)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        didFailParsing?(validationError)
    }
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

extension String {
    func toDate(withFormat format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        
        if let date = formatter.date(from: self) { return date }
        return nil
    }
}

extension Date {
    func toDisplayString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: self)
    }
}
