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
    var currentNewsItem: NewsData?
    var currentElement = ""
    var currentAttributes = [String:String]()
    var currentChar = ""
    var dateFormatter: DateFormatter?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI namespaceURL: String?, qualifiedName qName: String?, attributes attributeDict: [String:String]){
        
        currentElement = elementName
        currentAttributes = attributeDict
        currentChar = ""

        if elementName == "item"{
            
            let newsDataEntity = NSEntityDescription.entity(forEntityName: "NewsData", in: managedContext)
            
            managedContext.performAndWait({
                 self.currentNewsItem = NSManagedObject(entity: newsDataEntity!, insertInto: self.managedContext) as? NewsData
            })
           
            
        }
        
        if elementName == "media:content"{
            if let urlImage = currentAttributes["url"] {
                let newsImageEntity = NSEntityDescription.entity(forEntityName: "NewsImages", in: managedContext)
                managedContext.performAndWait({ 
                    if let newsImage = NSManagedObject(entity: newsImageEntity!, insertInto: self.managedContext) as? NewsImages{
                        newsImage.url = urlImage
                        self.currentNewsItem?.addToGetImages(newsImage)
                    }
                })
            }
        }
        
        if elementName == "enclosure"{
            if let imageURL = currentAttributes["url"]{
                managedContext.performAndWait({ 
                     self.currentNewsItem?.imageURL = imageURL
                })
               
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
       
        currentChar += string
    
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        managedContext.performAndWait {
            switch elementName {
            case "title":
                self.currentNewsItem?.newsTitle = self.currentChar
            case "description":
                self.currentNewsItem?.shortDesc = self.currentChar.EscapingHTMLTags()
            case "guid":
                self.currentNewsItem?.guid = self.currentChar
            case "link":
                self.currentNewsItem?.link = self.currentChar
            case "pubDate":
                self.currentNewsItem?.date = self.dateFormatter?.date(from: self.currentChar) as NSDate?
            case "item":
                if let guid = self.currentNewsItem?.guid {
                    if let currentNewsItem = self.currentNewsItem {
                        let predicate = NSPredicate(format: "guid == %@", guid)
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsData")
                        fetchRequest.predicate = predicate
                        fetchRequest.fetchBatchSize = 20
                        if let results = try? self.managedContext.fetch(fetchRequest) as! [NewsData] {
                            if results.count > 1 {
                                self.managedContext.delete(currentNewsItem)
                                self.currentNewsItem = nil
                            }
                        }
                    }
                }
                
            default:
                break
            }
        }
    }
    
    func parseData(data: Data) {
        parser?.abortParsing()
        parser = XMLParser(data: data)
        parser?.delegate = self
        parser?.parse()
    }
}


