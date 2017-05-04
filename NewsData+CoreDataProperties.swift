//
//  NewsData+CoreDataProperties.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 3/1/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation
import CoreData


extension NewsData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsData> {
        return NSFetchRequest<NewsData>(entityName: "NewsData");
    }
    
    @NSManaged public var date: NSDate?
    @NSManaged public var imagesForGallery: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var link: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var shortDesc: String?
    @NSManaged public var guid: String?
    @NSManaged public var getImages: NSSet?

}

// MARK: Generated accessors for getImages
extension NewsData {

    @objc(addGetImagesObject:)
    @NSManaged public func addToGetImages(_ value: NewsImages)

    @objc(removeGetImagesObject:)
    @NSManaged public func removeFromGetImages(_ value: NewsImages)

    @objc(addGetImages:)
    @NSManaged public func addToGetImages(_ values: NSSet)

    @objc(removeGetImages:)
    @NSManaged public func removeFromGetImages(_ values: NSSet)

}
