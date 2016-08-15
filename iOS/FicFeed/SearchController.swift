//
//  SearchController.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/25/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {    
    var results = [Int]() // contains indices of the results, in relation to TAGS/IDS arrays
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Browse"
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.barTintColor = UIColor(red: 0x8E, green: 0x00, blue: 0x00)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return results.count
        } else {
            return Info.TAGS.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TagCell", forIndexPath: indexPath)
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel!.text = Info.TAGS[results[indexPath.row]]
        } else {
            cell.textLabel!.text = Info.TAGS[indexPath.row]
        }
        return cell
    }
    
    func search(searchText: String) {
        let temp = Info.TAGS.filter({(tag: String) -> Bool in
            return tag.lowercaseString.containsString(searchText.lowercaseString) // TODO: implement handling abbreviations, alias, etc.
        })
        results.removeAll()
        for item in temp { results.append(Info.TAGS.indexOf(item)!) }
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResultsForSearchController(searchController)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        search(searchController.searchBar.text!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let feed = segue.destinationViewController as? FeedController {
            let index = tableView.indexPathForSelectedRow!.row
            if results.count != 0 {
                feed.feedId = Info.IDS[results[index]]
                feed.feedTitle = Info.TAGS[results[index]]
                feed.url = NSURL(string: "http://archiveofourown.org/tags/\(Info.IDS[results[index]])/feed.atom")
            } else {
                feed.feedId = Info.IDS[index]
                feed.feedTitle = Info.TAGS[index]
                feed.url = NSURL(string: "http://archiveofourown.org/tags/\(Info.IDS[index])/feed.atom")
            }
        }
    }
}
