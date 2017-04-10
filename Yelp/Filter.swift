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
    var filteredOptions: [FilterOption]?
    let isExclusive: Bool?
    var showAll: Bool? {
        didSet {
            if showAll! {
                filteredOptions = options
            } else {
                filteredOptions = [FilterOption]()
                for option in options! {
                    if (option.isOn) {
                        filteredOptions?.append(option)
                    }
                }
            }
        }
    }
    
    init(name: String, isExclusive: Bool, options: [FilterOption]) {
        self.name = name
        self.isExclusive = isExclusive
        self.options = options
        if isExclusive {
            filteredOptions = [FilterOption]()
            for option in options {
                if (option.isOn) {
                    self.filteredOptions?.append(option)
                }
            }
        } else {
            filteredOptions = options
        }
        self.showAll = false
    }
}
