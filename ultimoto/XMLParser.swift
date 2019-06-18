//
//  XMLParser.swift
//  ultimoto
//
//  Created by  on 13/6/19.
//  Copyright © 2019 Dave. All rights reserved.
//

import Foundation

struct RSSItem {
    var text: String
    var magnitude: String
    var time: String
}

class FeedParser: NSObject, XMLParserDelegate
{
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentText: String = "" {
        didSet {
            currentText = currentText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
    private var currentMagnitude: String = "" {
        didSet {
            currentMagnitude = currentMagnitude.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentTime: String = "" {
        didSet {
        currentTime = currentTime.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, respone, error) in
            guard let data = data else {
                if let error = error {
                    print (error.localizedDescription)
                }
                
                return
            }
            
            // empezamos el parseo
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "event" {
            currentText = ""
            currentMagnitude = ""
            currentTime = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "text": currentText += string
        case "standardError" : currentMagnitude += string
        case "creationTime" : currentTime = string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "event" {
            let rssItem = RSSItem(text: currentText, magnitude: currentMagnitude, time: currentTime)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
