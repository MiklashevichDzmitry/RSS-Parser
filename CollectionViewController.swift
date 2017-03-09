//
//  CollectionViewController.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 2/15/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentImages: [NewsImages]?
    let reuseIdentifier = "collectionCell"
    

    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        pageControl.numberOfPages = currentImages?.count ?? 0
        pageControl.tintColor = .red
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.currentPage = 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let currentImages = currentImages{
            return currentImages.count
        } else {   
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        if let item = currentImages?[indexPath.item].url {
            cell.collectionImage.imageFromUrl(urlString: item)
        }
        
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picSizeHeight = collectionView.frame.height
        let picSizeWidth = collectionView.frame.width - 20
        return CGSize(width: picSizeWidth, height: picSizeHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBOutlet weak var pageControl: UIPageControl!
    
   }
