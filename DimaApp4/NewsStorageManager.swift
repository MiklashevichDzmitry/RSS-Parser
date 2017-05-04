//
//  NewsStorageManager.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 4/21/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class NewsStorageManager {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let sharedInstance = {
        return NewsStorageManager()
    }()
    
    static let updateNotificationKey = Notification.Name("updateNotificationKey")
    
   
    let dateFormatter = DateFormatter()
    weak var delegate: NewsLoaderDelegate?

    
    
    func createNewsList(newsDictionaryArray: [Dictionary<String, Any>]) {
        
        var newsDate: NSDate?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "US_en") as Locale!
       
        let newsList = fetchCurrentObjects()
        
        for newsDict in newsDictionaryArray {
            
            let newsTitle = newsDict["newsTitle"] != nil ? (newsDict["newsTitle"]!) as? String : ""
            let newsDescription = newsDict["newsDescription"] != nil ? (newsDict["newsDescription"]!) as? String : ""
            let newsImageURL = newsDict["newsImageURL"] != nil ? (newsDict["newsImageURL"]!) as? String : ""
            let newsImagesForGallery = newsDict["imagesForGallery"] != nil ? (newsDict["imagesForGallery"]!) as? [String] : [""]
            let newsLink = newsDict["newsLink"] != nil ? (newsDict["newsLink"]!) as? String : ""
            let newsDateString = newsDict["newsDate"] != nil ? (newsDict["newsDate"]!) as? String : ""
        
           
            var presence = false
            for news in newsList {
               if news.newsTitle! == newsTitle{
                    presence = true
                    break
                } else {
                    presence = false
                }
            }
            
            if let date = dateFormatter.date(from: newsDateString!) {
                newsDate = date as NSDate?
            }

            
            if !presence {
                saveNewsObject(newsTitle: newsTitle! , newsDescription: newsDescription! , newsImageURL: newsImageURL!, imagesForGallery: newsImagesForGallery!, newsLink: newsLink! , newsDate: newsDate!)
                
            }
        }
        NotificationCenter.default.post(name: NewsStorageManager.updateNotificationKey, object: nil)
        appDelegate.saveContext()
    }
    
    func fetchCurrentObjects() -> [NewsData] {
        
        var newsList = [NewsData]()
        //let predicate = NSPredicate(format: "guid == %@", newsLink)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsData")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        do {
            newsList = try managedContext.fetch(fetchRequest) as! [NewsData]
        } catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        return newsList
    }
    
    
    func saveNewsObject(newsTitle: String, newsDescription: String, newsImageURL: String, imagesForGallery: [String], newsLink: String, newsDate: NSDate) {
        
        let newsEntity = NSEntityDescription.entity(forEntityName: "NewsData", in: managedContext)
        let newsImageEntity = NSEntityDescription.entity(forEntityName: "NewsImages", in: managedContext)
        
        
        
        managedContext.performAndWait {
            
            if let createdNewsObject = NSManagedObject(entity: newsEntity!, insertInto: self.managedContext) as? NewsData {
                createdNewsObject.newsTitle = newsTitle
                createdNewsObject.shortDesc = newsDescription
                createdNewsObject.date = newsDate
                createdNewsObject.link = newsLink
                createdNewsObject.imageURL = newsImageURL
                
                for imageForGallery in imagesForGallery {
                    if let newsImage = NSManagedObject(entity: newsImageEntity!, insertInto: self.managedContext) as? NewsImages {
                        newsImage.url = imageForGallery
                        createdNewsObject.addToGetImages(newsImage)
                    }
                }
            }
        }
    }
}










