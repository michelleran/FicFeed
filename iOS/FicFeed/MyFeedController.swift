//
//  MyFeedController.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/27/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

class MyFeedController: UITableViewController {
    var subscribed: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Feed"
    }
    
    override func viewWillAppear(animated: Bool) {
        Cloud.getSubscribedTags { (subscribed: [Int]) in
            self.subscribed = subscribed
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribed.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyFeedCell")!
        let id = subscribed[indexPath.row]
        if let index = Info.IDS.indexOf(id) {
            cell.textLabel!.text = Info.TAGS[index]
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let feed = segue.destinationViewController as? FeedController {
            let index = tableView.indexPathForSelectedRow!.row
            feed.feedId = subscribed[index]
            if let i = Info.IDS.indexOf(subscribed[index]) {
                feed.feedTitle = Info.TAGS[i]
            }
            feed.url = NSURL(string: "http://archiveofourown.org/tags/\(subscribed[index])/feed.atom")
        }
    }
}
