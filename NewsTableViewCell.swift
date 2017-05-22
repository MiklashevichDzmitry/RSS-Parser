//
//  NewsTableViewCell.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/5/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import UIKit
import CoreData

class NewsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var ifGalleryLabel: UILabel!
   
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var newsImage: LoadingImageView!
            
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var zeroWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var universalWidth: NSLayoutConstraint!
    
//    var currentNews: [NewsData]?
//
//    required init?(coder aDecoder: NSCoder) {
//        
//        super.init(coder: aDecoder)
//        self.currentNews = NewsStorageManager.sharedInstance.fetchCurrentObjects()
//        
//    }
    
//    var shouldHideImage: Bool {
//     
//        get {return self.newsImage.image == nil}
//        
//        set{zeroWidthConstraint.isActive = true}
//        
//    }

//    func shouldHideImage() {
      
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newsImageEntity = NSEntityDescription.entity(forEntityName: "NewsData", in: managedContext)
//        if let newsImage = NSManagedObject(entity: newsImageEntity!, insertInto: managedContext) as? NewsData {
//            //if let newsImage = newsImage.imageURL{
//                if newsImage.imageURL == nil {
//                    self.universalWidth.constant = 0
//                //}
//            }
//        }
//        if let item = currentNews {
//            for element in item {
//                if element.imageURL == nil {
//                    self.zeroWidthConstraint.constant = 0
//                }
//            }
//        }
//        
//    }
    
    func shouldHideImage(newsImageURL: String?){
        if newsImageURL == nil {
            self.universalWidth.isActive = false
            self.zeroWidthConstraint.isActive = true
        } else {
            self.universalWidth.isActive = true
        }
    }
    
    override func prepareForReuse() {
        
        if self.zeroWidthConstraint.isActive == true {
            self.zeroWidthConstraint.isActive = false
        }
        
    }
   /* override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/

    }


