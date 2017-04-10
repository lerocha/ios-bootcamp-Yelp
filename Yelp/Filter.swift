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
    
    class func createFilters() -> [Filter] {
        return [
            Filter(name: "Offering a Deal", isExclusive: false, options: [
                FilterOption(value: nil, title: "Offering a Deal"),
                ]),
            Filter(name: "Distance", isExclusive: true, options: [
                FilterOption(value: 0, title: "Best Match", isOn: true),
                FilterOption(value: 1, title: "0.3 miles"),
                FilterOption(value: 2, title: "1 mile"),
                FilterOption(value: 3, title: "5 miles"),
                FilterOption(value: 4, title: "20 miles"),
                ]),
            Filter(name: "Sort By", isExclusive: true, options: [
                FilterOption(value: YelpSortMode.bestMatched, title: "Best Match", isOn: true),
                FilterOption(value: YelpSortMode.distance, title: "Distance"),
                FilterOption(value: YelpSortMode.highestRated, title: "Rating"),
                FilterOption(value: YelpSortMode.highestRated, title: "Most Reviewed"),
                ]),
            Filter(name: "Category", isExclusive: false, options:
                getYelpCategoryFilterOptions()
            ),
        ];
    }
    
    class func getYelpCategoryFilterOptions() -> [FilterOption] {
        var options = [FilterOption]()
        
        // read categories.json from Yelp
        if let url = Bundle.main.url(forResource: "Data/categories", withExtension: "json") {
            let data = try! Data(contentsOf: url)
            if let json = try! JSONSerialization.jsonObject(with: data, options:[]) as? [NSDictionary] {
                for dict in json {
                    let option = FilterOption(categoryDict: dict as NSDictionary)
                    if (option.parents?.contains("restaurants"))! {
                        options.append(option)
                    }
                }
            }
        }
        
        return options
    }
}
