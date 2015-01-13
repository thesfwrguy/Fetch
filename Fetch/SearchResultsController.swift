//
//  SearchResultsController.swift
//  Fetch
//
//  Created by Kanishka Goel on 2015-01-13.
//  Copyright (c) 2015 Kanishka Goel. All rights reserved.
//

import UIKit

private let longNameSize = 6
private let shortNamesButtonIndex = 1
private let longNamesButtonIndex = 2

class SearchResultsController: UITableViewController, UISearchResultsUpdating, IMDbAPIControllerDelegate {
    
    let sectionsTableIdentifier = "SectionsTableIdentifier"
    var names:[String: [String]] = [String: [String]]()
    var keys: [String] = []
    var filteredNames: [String] = []
    var filteredIDs: [String] = []
    var filteredTypes: [String] = []
    var filteredRelease: [String] = []
    lazy var imdbSearch: IMDbAPIController = IMDbAPIController(delegate: self)

    override func viewDidLoad() {

        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: sectionsTableIdentifier)
        
        self.imdbSearch.delegate = self

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return filteredNames.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(sectionsTableIdentifier) as UITableViewCell
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: sectionsTableIdentifier)
        cell.textLabel?.text = filteredNames[indexPath.row]
        cell.detailTextLabel?.text = filteredRelease[indexPath.row] + " | " + filteredTypes[indexPath.row].uppercaseString
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        tableView.rowHeight = 75
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchString = searchController.searchBar.text
        let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
//        println("************")
//        println("before clearing: \n\(filteredNames)")
        
        filteredNames.removeAll(keepCapacity: true)
        filteredIDs.removeAll(keepCapacity: true)
        filteredTypes.removeAll(keepCapacity: true)
        filteredRelease.removeAll(keepCapacity: true)
//        println("************")
//        println("after clearing: \n\(filteredNames)")
        
        if searchString.utf16Count > 0 {
            
            imdbSearch.searchIMDb(searchString)
            
//            println("************")
//            println("after searching: \n\(movieNameArray)")
            
            for var i = 0; i < movieNameArray.count; i++ {
                
                if movieTypeArray[i] == "movie" || movieTypeArray[i] == "series" {
                
                    filteredNames.append(movieNameArray[i])
                    filteredIDs.append(movieIDArray[i])
                    filteredRelease.append(movieReleaseArray[i])
                    filteredTypes.append(movieTypeArray[i])
                    
                }
                
            }
            
        }
        tableView.reloadData()
    }
    
    func didFinishIMDbSearch (result : Dictionary<String, String>) {
        
    }

    
}
