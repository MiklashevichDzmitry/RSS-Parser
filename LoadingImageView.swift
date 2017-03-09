//
//  LoadingImageView.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/30/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation
import UIKit

class LoadingImageView: UIImageView {
 
    var spinner: UIActivityIndicatorView!
    var loadTask: URLSessionDataTask?
    var session: URLSession?
    
    required init?(coder aDecoder: NSCoder) {
        self.session = URLSession(configuration: .default)
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        spinner.backgroundColor = UIColor.gray
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        let viewSpinner = ["spinner": spinner]
        var spinnerConstrains = [NSLayoutConstraint]()
        let spinnerVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[spinner]|", options: [], metrics: nil, views: viewSpinner)
        spinnerConstrains += spinnerVerticalConstraint
        let spinnerHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "|[spinner]|", options: [], metrics: nil, views: viewSpinner)
        spinnerConstrains += spinnerHorizontalConstraint
        NSLayoutConstraint.activate(spinnerConstrains)
    }
    
    public func imageFromUrl(urlString: String) {
        spinner.startAnimating()
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 1
            loadTask?.cancel()
            loadTask = session?.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let data = data{
                    DispatchQueue.main.async{
                        self.image = UIImage(data: data)
                        self.spinner.stopAnimating()
                    }
                } else {
                    self.image = #imageLiteral(resourceName: "No_Photo_Available")
                    self.spinner.stopAnimating()
                }
            }); loadTask?.resume()
        }
    }
}



