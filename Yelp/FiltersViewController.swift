//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Rocha, Luis on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var filters: [Filter]!
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)

        // Build the sections.
        filters = [
            Filter(name: "Offering a Deal", options: [
                FilterOption(value: nil, title: "Offering a Deal"),
            ]),
            Filter(name: "Distance", options: [
                FilterOption(value: 0, title: "Best Match", isOn: true),
                FilterOption(value: 1, title: "0.3 miles"),
                FilterOption(value: 2, title: "1 mile"),
                FilterOption(value: 3, title: "5 miles"),
                FilterOption(value: 4, title: "20 miles"),
            ]),
            Filter(name: "Sort By", options: [
                FilterOption(value: YelpSortMode.bestMatched, title: "Best Match", isOn: true),
                FilterOption(value: YelpSortMode.distance, title: "Distance"),
                FilterOption(value: YelpSortMode.highestRated, title: "Rating"),
                FilterOption(value: YelpSortMode.highestRated, title: "Most Reviewed"),
            ]),
            Filter(name: "Category", options:
                getYelpCategoryFilterOptions()
            ),
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()

        // deals
        filters["deals"] = self.filters[0].options?[0].isOn as AnyObject
        
        // distance
        for filterOption in self.filters[1].options! {
            if filterOption.isOn {
                filters["distance"] = filterOption.value as AnyObject
                break
            }
        }
        
        // sort
        for filterOption in self.filters[2].options! {
            if filterOption.isOn {
                filters["sort"] = filterOption.value as AnyObject
                break
            }
        }
        
        // categories
        var selectedCategories = [String]()
        for category in (self.filters[3].options)! {
            if category.isOn {
                selectedCategories.append(category.value as! String)
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (filters[section].options?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.model = filters[indexPath.section].options?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)!
        header.textLabel?.text = filters[section].name
        return header
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        filters[indexPath.section].options?[indexPath.row].isOn = value
    }
    
    func getYelpCategoryFilterOptions() -> [FilterOption] {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
