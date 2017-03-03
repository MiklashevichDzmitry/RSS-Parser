//
//  NewsImages+CoreDataProperties.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 3/1/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation
import CoreData


extension NewsImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsImages> {
        return NSFetchRequest<NewsImages>(entityName: "NewsImages");
    }

    @NSManaged public var url: String?
    @NSManaged public var getImages: NewsData?

}
