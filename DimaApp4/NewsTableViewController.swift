//
//  NewsTableViewController.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/5/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import UIKit
import CoreData

class NewsTableViewController: UITableViewController, NewsLoaderDelegate, NSFetchedResultsControllerDelegate {
    
    var selectedIndex: Int = 1
    
    var newsLoader: NewsLoader
    let dateFormatter = DateFormatter()
    
    let fetchedResultsController = NewsStorageManager.sharedInstance.allNewsFetchedResultsController()
    
    required init?(coder aDecoder: NSCoder) {
        self.newsLoader = NewsLoader()
        super.init(coder: aDecoder)
        self.newsLoader.delegate = self
        dateFormatter.dateFormat = "EEE, dd MMM yyyy, HH:mm"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NewsStorageManager.updateNotificationKey, object: nil, queue: nil) { [weak self] notification in
            guard let strongSelf = self else {return}
            do {
                try strongSelf.fetchedResultsController.performFetch()
            } catch let err {
                print(err)
            }
            
            strongSelf.refreshUI()
        }
    }

    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        super.viewDidLoad()
        reloadData()
        self.refreshControl?.addTarget(self, action: #selector(NewsTableViewController.reloadData), for: UIControlEvents.valueChanged)
        newsLoader.loadNews()
    }
    
    func reloadData() {
        
        newsLoader.loadNews()
        
          }
    
    func refreshUI() {
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
       
    }

    func didLoadNews(news: [NewsData]) {
        refreshUI()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        let count = fetchedResultsController.sections?[section].numberOfObjects
        return count ?? 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NewsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        
        let item = fetchedResultsController.object(at: indexPath) as! NewsData
        
        if let currentImages = item.getImages {
            if currentImages.count > 1  {
                cell.ifGalleryLabel.isHidden = false
                cell.ifGalleryLabel.text = "Gallery [\(item.getImages!.count)]"
            } else {
                cell.ifGalleryLabel.isHidden = true
            }
            cell.shouldHideImage(newsImageURL: item.imageURL)
        }
  
        cell.dateLabel.text = dateFormatter.string(from: (item.value(forKey: "date") as? Date)!)
        cell.titleLabel.text = item.value(forKey: "newsTitle") as! String?
        if let newsImage = item.value(forKey: "imageURL") {
            cell.newsImage.imageFromUrl(urlString: newsImage as! String)
        }
        return cell
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "detailSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let detailViewController = segue.destination as! DetailViewController
            if let fetchedObjects = fetchedResultsController.fetchedObjects, selectedIndex < fetchedObjects.count  {
                detailViewController.newsData = fetchedObjects[selectedIndex] as? NewsData
            }
        }
    }
}












