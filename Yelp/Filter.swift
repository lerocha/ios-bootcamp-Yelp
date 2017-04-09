//
//  Filter.swift
//  Yelp
//
//  Created by Luis Rocha on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class Filter: NSObject {
    let name: String?
    let options: [FilterOption]?
    
    init(name: String, options: [FilterOption]) {
        self.name = name
        self.options = options
    }
}
