//
//  FicController.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/24/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class FicController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    
    var ficTitle: String = ""
    var link: NSURL = NSURL(string: "http://archiveofourown.org/")! // placeholder
    
    var webView: WKWebView!
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ficTitle
        progressView.progressTintColor = UIColor(red: 0xCC, green: 0x5A, blue: 0x5A)
        
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: #selector(FicController.back))
        forwardButton = UIBarButtonItem(image: UIImage(named: "forward"), style: .Plain, target: self, action: #selector(FicController.forward))
        backButton.enabled = false
        forwardButton.enabled = false
        navigationItem.rightBarButtonItems = [forwardButton, backButton]
        
        view.insertSubview(webView, belowSubview: progressView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.loadRequest(NSURLRequest(URL: link))
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "loading") {
            backButton.enabled = webView.canGoBack
            forwardButton.enabled = webView.canGoForward
        } else if (keyPath == "estimatedProgress") {
            progressView.hidden = (webView.estimatedProgress == 1)
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func back() { webView.goBack() }
    
    func forward() { webView.goForward() }
}