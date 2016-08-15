//
//  FeedController.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/24/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import UIKit
import MWFeedParser
import Firebase
import FirebaseMessaging

class FeedController: UITableViewController, MWFeedParserDelegate {
    @IBOutlet var button: UIBarButtonItem!
    
    @IBAction func pressed(sender: UIBarButtonItem) {
        if sender.title == "Track" {
            Cloud.subscribeTo(feedId)
            sender.title = "Untrack"
        } else {
            Cloud.unsubscribeFrom(feedId)
            sender.title = "Track"
        }
    }
    
    var url: NSURL?
    var parser: MWFeedParser!
    var feedId: Int = 0
    var feedTitle: String = "Feed"
    var fics: [[String: String]] = []
    
    var refresh: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
        navigationItem.title = feedTitle
        if let u = url {
            parser = MWFeedParser(feedURL: u)
            parser.delegate = self
            parser.parse()
            refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(FeedController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
            refreshControl = refresh
        } else {
            Popup.pop("Error", message: "Couldn't load feed.", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        Cloud.getSubscribedTags { (subscribed: [Int]) in
            if subscribed.contains(self.feedId) {
                self.button.title = "Untrack"
            } else {
                self.button.title = "Track"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        fics.removeAll()
        parser.parse() // a very clunky refresh method for rn
        refreshControl.endRefreshing()
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        var info = Extrekt.extractInfo(item.summary)
        info["author"] = item.author
        info["title"] = Extrekt.charHelper(item.title)
        info["link"] = item.link
        fics.append(info)
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fics.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FicCell = tableView.dequeueReusableCellWithIdentifier("FicCell", forIndexPath: indexPath) as! FicCell
        let fic = fics[indexPath.row]
        cell.title.text = fic["title"]
        cell.author.text = "by " + fic["author"]!
        cell.warnings.text = fic["warnings"]
        cell.relationships.text = fic["ships"]
        cell.summary.text = fic["summary"]
        cell.rating.text = fic ["rating"]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ficController = segue.destinationViewController as? FicController {
            let selected = fics[tableView.indexPathForSelectedRow!.row]
            ficController.ficTitle = selected["title"]!
            ficController.link = NSURL(string: selected["link"]!)!
        }
    }
}

