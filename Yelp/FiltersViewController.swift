//
//  FiltersViewController.swift
//  Yelp
//
//  Created by tingting_gao on 10/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:[String:AnyObject] )
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String: String]]!
    var sortMethods = ["Best Match", "Distance", "Highest Rated"]
    var sortModes = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
    var distances = ["Automatic", "3 miles", "5 miles", "10 miles", "20 miles"]
    var distanceValues = [0, 3*1609, 5*1609, 10*1609, 20*1609]
    var switchStates = [Int: Bool]()
    var sectionNames = ["Deals", "Distance", "Sort", "Category"]
    var dealsOn = false
    var sortMode: Int = -1
    var distanceIndex: Int = -1
    var distance: Int = -1
    var sortHasExpanded = false
    var distanceHasExpanded = false
    var categoriesHasExpanded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }*/
    
    @IBAction func onCancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: AnyObject) {
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()

        for (index, selected) in switchStates {
            if selected {
                selectedCategories.append(categories[index]["code"]!)
            }
        }

        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }

        filters["deals"] = dealsOn as AnyObject?

        if sortMode > -1 {
            filters["sort"] = sortModes[sortMode] as AnyObject?
        }

        if distance > 0 {
            filters["radius_filter"] = distance as AnyObject?
        }

        delegate?.filtersViewController!(filtersViewController: self, didUpdateFilters: filters)

        dismiss(animated: true, completion: nil)
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 4
        }
        else if section == 2 {
            return sortMethods.count
        }
        else if section == 3 {
            return categories.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell")! as! DealCell
            cell.dealLabel.text = "Offering a Deal"
            cell.dealSwitch.isOn = dealsOn ?? false
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell")! as! DistanceCell
            cell.distanceLabel.text = distances[indexPath.row]
            cell.checkmarkView.image = UIImage(named: "checkmark")
            if indexPath.row == distanceIndex {
                cell.checkmarkView.isHidden = false
            }
            else {
                cell.checkmarkView.isHidden = true
            }
            if indexPath.row == 0 && !distanceHasExpanded {
                cell.checkmarkView.image = UIImage(named: "triangle")
                cell.checkmarkView.isHidden = false
            }
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell")! as! SortCell
            cell.sortLabel.text = sortMethods[indexPath.row]
            cell.checkView.image = UIImage(named: "checkmark")
            if indexPath.row == sortMode {
                cell.checkView.isHidden = false
            }
            else {
                cell.checkView.isHidden = true
            }
            if indexPath.row == 0 && !sortHasExpanded {
                cell.checkView.image = UIImage(named: "triangle")
                cell.checkView.isHidden = false

            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false


            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }

    func dealCell(dealCell: DealCell, didChangeValue value: Bool) {
        dealsOn = value
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Distance mode 
        if indexPath.section == 1 {
            if distanceHasExpanded {
                clearDistanceCells(row: 3, section: 1)
                let cell = tableView.cellForRow(at: indexPath) as! DistanceCell
                cell.checkmarkView.isHidden = false
                distanceIndex = indexPath.row
                distance = distanceValues[indexPath.row]
                tableView.reloadSections(IndexSet([1]), with: UITableViewRowAnimation.none)
                print("the distance option is \(distance)")
            }
            else {
                distanceHasExpanded = true
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! DistanceCell
                cell.checkmarkView.image = UIImage(named: "checkmark")
                cell.checkmarkView.isHidden = true
                tableView.reloadSections(IndexSet([1]), with: UITableViewRowAnimation.none)
            }
        }
        // Sort mode
        else if indexPath.section == 2 {
            if sortHasExpanded {
            // Only one cell can be selected, clear the other cells
                clearSortCells(row: 2, section: 2)
                let cell = tableView.cellForRow(at: indexPath) as! SortCell
                cell.checkView.isHidden = false
                sortMode = indexPath.row
            tableView.reloadSections(IndexSet([2]), with: UITableViewRowAnimation.none)
            }
            else {
                sortHasExpanded = true
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! SortCell
                cell.checkView.image = UIImage(named: "checkmark")
                cell.checkView.isHidden = true
                tableView.reloadSections(IndexSet([2]), with: UITableViewRowAnimation.none)
            }
        }
    }

    func clearDistanceCells(row: Int, section: Int) {
        for i in 0...row {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! DistanceCell
            cell.checkmarkView.isHidden = true
        }
    }

    func clearSortCells(row: Int, section: Int) {
        for i in 0...row {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! SortCell
            cell.checkView.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && !distanceHasExpanded && indexPath.row > 0 {
            return 0
        }
        else if indexPath.section == 2 && !sortHasExpanded && indexPath.row > 0{
            return 0
        }
        /* else if indexPath.section == 3 && !categoriesHasExpanded && indexPath.row > 2 {
            return 0
        } */
        else {
            return 68.0
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    
//    }
    

}
