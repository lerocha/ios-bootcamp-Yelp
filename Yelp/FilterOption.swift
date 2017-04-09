//
//  FilterOption.swift
//  Yelp
//
//  Created by Rocha, Luis on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FilterOption: NSObject {
    let value: Any?
    let title: String?
    let parents: [String]?
    var isOn: Bool = false
    
    init(value: Any?, title: String) {
        self.value = value
        self.title = title
        self.parents = [String]()
    }
    
    init(value: Any?, title: String, isOn: Bool) {
        self.value = value
        self.title = title
        self.isOn = isOn
        self.parents = [String]()
    }
    
    init(categoryDict: NSDictionary) {
        self.value = categoryDict["alias"] as? String
        self.title = categoryDict["title"] as? String
        self.parents = categoryDict["parents"] as? [String]
    }
}
