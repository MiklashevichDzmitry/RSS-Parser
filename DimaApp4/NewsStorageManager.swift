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
    private var managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //private var privateManagedContext = (UIApplication.shared.delegate as! AppDelegate).privateManagedObjectContext
  
    
    static let sharedInstance = {
        return NewsStorageManager()
    }()
    
    static let updateNotificationKey = Notification.Name("updateNotificationKey")
    
    
    let dateFormatter = DateFormatter()
    weak var delegate: NewsLoaderDelegate?
    
    func allNewsFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsData")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func createNewsList(newsDictionaryArray: [Dictionary<String, Any>]) {
        
        var newsDate: NSDate?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "US_en") as Locale!
        
        for newsDict in newsDictionaryArray {
            
            let newsTitle = newsDict["newsTitle"] != nil ? (newsDict["newsTitle"]!) as? String : ""
            let newsDescription = newsDict["newsDescription"] != nil ? (newsDict["newsDescription"]!) as? String : ""
            let newsImageURL = newsDict["newsImageURL"] != nil ? (newsDict["newsImageURL"]!) as? String : nil
            let newsImagesForGallery = newsDict["imagesForGallery"] != nil ? (newsDict["imagesForGallery"]!) as? [String] : [""]
            guard let newsLink = newsDict["newsLink"] != nil ? (newsDict["newsLink"]!) as? String : "" else {return}
            let newsDateString = newsDict["newsDate"] != nil ? (newsDict["newsDate"]!) as? String : ""
            
            if let date = dateFormatter.date(from: newsDateString!) {
                newsDate = date as NSDate?
            }
            
            if let presense = presense(guid: newsLink), presense {

                    saveNewsObject(newsTitle: newsTitle! , newsDescription: newsDescription! , newsImageURL: newsImageURL, imagesForGallery: newsImagesForGallery!, newsLink: newsLink, newsDate: newsDate!)
                
            }
            
        }
        NotificationCenter.default.post(name: NewsStorageManager.updateNotificationKey, object: nil)
        appDelegate.saveContext()
    }
    
    func presense(guid: String) -> Bool? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsData")
        let predicate = NSPredicate(format: "guid == %@", guid)
        fetchRequest.predicate = predicate
        if let results = try? self.managedContext.fetch(fetchRequest) {
            return results.isEmpty
        } else {
            return nil
        }
    }
    
    
    func saveNewsObject(newsTitle: String, newsDescription: String, newsImageURL: String?, imagesForGallery: [String], newsLink: String , newsDate: NSDate) {
        
        managedContext.performAndWait {

            let newsEntity = NSEntityDescription.entity(forEntityName: "NewsData", in: self.managedContext)
            let newsImageEntity = NSEntityDescription.entity(forEntityName: "NewsImages", in: self.managedContext)

            if let createdNewsObject = NSManagedObject(entity: newsEntity!, insertInto: self.managedContext) as? NewsData {
                createdNewsObject.newsTitle = newsTitle
                createdNewsObject.shortDesc = newsDescription
                createdNewsObject.date = newsDate
                createdNewsObject.link = newsLink
                createdNewsObject.guid = newsLink
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










