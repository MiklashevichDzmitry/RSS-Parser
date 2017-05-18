//
//  Parser.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/24/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class Parser: NSObject, XMLParserDelegate {
    
    
    var parser: XMLParser?
    var currentNewsItem = [String: Any]()
    var parsedNews = [Dictionary<String, Any>]()
    private var currentElement = ""
    private var currentAttributes = [String: String]()
    private var currentChar: String?
    
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI namespaceURL: String?, qualifiedName qName: String?, attributes attributeDict: [String:String]){
        
        currentElement = elementName
        currentAttributes = attributeDict
        currentChar = ""
        
        if elementName == "enclosure"{
            
            if let imageURL = currentAttributes["url"]{
                currentChar = imageURL
                if imageURL.contains(".mp4") {
                    currentChar = nil
                }
                
            }
        }
        
        if elementName == "media:content"{
            if let urlImage = currentAttributes["url"] {
                currentChar = urlImage
                if urlImage.contains(".mp4"){
                    currentChar = nil
                }
                
            }
            
        }
    }
    

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        guard (currentChar?.append(string)) != nil else {return}
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if currentChar == nil {return}
        
        switch elementName {
        case "title":
            currentNewsItem["newsTitle"] = currentChar
            
        case "description":
            currentNewsItem["newsDescription"] = currentChar?.escapingHTMLTags()
            
        case "guid":
            currentNewsItem["newsLink"] = currentChar
            
        case "enclosure":
//            if currentChar == ".mp4" {
//                currentChar = nil
//            } else {
            
                currentNewsItem["newsImageURL"] = currentChar
//            }
            
        case "media:content":
            
            if currentNewsItem["imagesForGallery"] == nil {
                currentNewsItem["imagesForGallery"] = [String]()
            }
            
            if var imagesForGallery = currentNewsItem["imagesForGallery"] as? [String] { // TODO: fix
                imagesForGallery.append(currentChar!)
                currentNewsItem["imagesForGallery"] = imagesForGallery
            }
            
        case "link":
            currentNewsItem["newsLink"] = currentChar
            
        case "pubDate":
            currentNewsItem["newsDate"] = currentChar
            
        case "item":
            parsedNews.append(currentNewsItem)
            currentNewsItem = ["": ""]
        default:
            break
        }
        
    }
    
    func parseData(data: Data) -> [Dictionary<String, Any>] {
        parser?.abortParsing()
        parser = XMLParser(data: data)
        parser?.delegate = self
        parsedNews.removeAll()
        parser?.parse()
        return parsedNews
    }
}

        
        
        



