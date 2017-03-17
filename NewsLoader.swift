//
//  File.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/26/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SystemConfiguration

protocol NewsLoaderDelegate {
    
    func didLoadNews(news: [NewsData])

}

class NewsLoader {
    

    var isLoading = false
    var delegate: NewsLoaderDelegate? = nil
    var newsTableViewCell = NewsTableViewCell()
    
    func loadNews(){
        if isLoading {
            return
        }
        isLoading = true
        let todoEndpoint: String = "http://news.tut.by/rss/index.rss"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let data = data {
                let parser = Parser()
                parser.parseData(data: data)
                self.isLoading = false
                DispatchQueue.main.async {
                    parser.appDelegate.saveContext()
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsData")
                    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    do {
                        if let results = try managedContext.fetch(fetchRequest) as? [NewsData] {
                            self.delegate?.didLoadNews(news: results)
                        }
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                }
                if let error = error{
                    print("Error:\(error) + Description:\(error.localizedDescription)")
                    return
                }
                
                
            }
        })
        
        task.resume()
    }
    
    class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}



