//
//  Section.swift
//  Yelp
//
//  Created by Luis Rocha on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class Section: NSObject {
    var name: String?
    var data: [Category]?
    
    init(name: String, data: [Category]) {
        self.name = name
        self.data = data
    }
    
    init(name: String) {
        self.name = name
        let category = Category(alias: "", title: name)
        self.data = [Category]()
        self.data?.append(category)
    }
}
