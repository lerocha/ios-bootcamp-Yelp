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
    
    var sections: [Section] = [
        Section(name: "Offering a Deal"),
        Section(name: "Distance"),
        Section(name: "Sort By"),
        Section(name: "Category")
    ]
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)

        // Do any additional setup after loading the view.
        sections[3].data = yelpCategories()
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
        
        var selectedCategories = [String]()
        for category in (sections[3].data)! {
            if category.isOn {
                selectedCategories.append(category.alias!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section].data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.model = sections[indexPath.section].data?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)!
        header.textLabel?.text = sections[section].name
        return header
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        sections[indexPath.section].data?[indexPath.row].isOn = value
    }
    
    func yelpCategories() -> [Category] {
        var categories = [Category]()
        
        // read categories.json from Yelp
        if let url = Bundle.main.url(forResource: "Data/categories", withExtension: "json") {
            let data = try! Data(contentsOf: url)
            if let json = try! JSONSerialization.jsonObject(with: data, options:[]) as? [NSDictionary] {
                for dict in json {
                    let category = Category(categoryDict: dict as NSDictionary)
                    if (category.parents?.contains("restaurants"))! {
                        categories.append(category)
                    }
                }
            }
        }
        
        return categories
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
