//
//  Category.swift
//  Yelp
//
//  Created by Rocha, Luis on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class Category: NSObject {
    let alias: String?
    let title: String?
    let parents: [String]?
    var isOn: Bool = false
    
    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
        self.parents = [String]()
    }
    
    init(categoryDict: NSDictionary) {
        self.alias = categoryDict["alias"] as? String
        self.title = categoryDict["title"] as? String
        self.parents = categoryDict["parents"] as? [String]
    }
}
