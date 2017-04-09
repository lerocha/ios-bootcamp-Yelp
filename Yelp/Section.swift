//
//  Section.swift
//  Yelp
//
//  Created by Luis Rocha on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class Section: NSObject {
    let name: String?
    let data: [Category]?
    
    init(name: String, data: [Category]) {
        self.name = name
        self.data = data
    }
}
