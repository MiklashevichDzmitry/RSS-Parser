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

protocol NewsLoaderDelegate: class {
    
    func didLoadNews(news: [NewsData])

}


class NewsLoader {
    
    let parser = Parser()
    let newsStorage = NewsStorageManager()
    var isLoading = false

    weak var delegate: NewsLoaderDelegate? = nil
    
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
        let task = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
            if let data = data {
                guard let strongSelf = self else {return}
                strongSelf.isLoading = false
                var parsedData = [Dictionary<String, Any>]()
                parsedData = strongSelf.parser.parseData(data: data)
                DispatchQueue.main.async {
                    
                    if self?.newsStorage != nil {
                        NewsStorageManager.sharedInstance.createNewsList(newsDictionaryArray: (parsedData as? [Dictionary<String, Any>])!)
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



