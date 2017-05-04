//
//  ViewController.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 12/29/16.
//  Copyright © 2016 Dzmitry Miklashevich. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var newsData: NewsData?
       
    override func viewWillAppear(_ animated: Bool) {
        
        if let newsItem = newsData{
            shortDescriptionLabel.text = newsItem.shortDesc
        }
        
        if let newsItemImageUrl = newsData?.imageURL{
            detailImage.imageFromUrl(urlString: newsItemImageUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        detailImage.isUserInteractionEnabled = true
        detailImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    @IBOutlet weak var detailImage: LoadingImageView!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    
    func imageTapped(sender: UITapGestureRecognizer){
        
        if let collectionViewController = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            collectionViewController.navigationItem.title = newsData?.newsTitle
            collectionViewController.currentImages = newsData?.getImages?.allObjects as? [NewsImages]
            self.present(collectionViewController, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func sourceButton(_ sender: AnyObject) {
        if let newsItemLink = newsData?.link {
            if let url = URL(string: newsItemLink){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}








