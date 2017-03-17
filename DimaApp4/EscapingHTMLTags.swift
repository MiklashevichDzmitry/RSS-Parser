//
//  ExtensionString.swift
//  DimaApp4
//
//  Created by Dzmitry Miklashevich on 1/27/17.
//  Copyright © 2017 Dzmitry Miklashevich. All rights reserved.
//

import Foundation

extension String {
    
    public func escapingHTMLTags() -> String {
        
        let delChar = "<[^>]+>"
        let range = NSMakeRange(0, characters.count)
        let regularExpression = try! NSRegularExpression(pattern: delChar, options: [])
        return regularExpression.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
}

