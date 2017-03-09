//
//  NewsScrollView.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/5/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import UIKit

class NewsScrollView: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "image.png"))
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.contentOffset = CGPoint(x: 1000, y: 450)
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        setZoomScale()
        setupGestureRecognizer()
        
    }
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    private func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    private func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: Selector(("handleDoubleTap:")))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
   private func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}


