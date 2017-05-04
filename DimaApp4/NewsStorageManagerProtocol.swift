//
//  NewsStorageManagerProtocol.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 4/27/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation

protocol NewsStorageManagerProtocol: class {
   
    func createNewsList(newsDictionaryArray: [Dictionary<String, String>])
        
}
