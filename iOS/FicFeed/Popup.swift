//
//  Popup.swift
//  FicFeed
//
//  Created by Michelle Ran on 8/8/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

public class Popup {
    public static func pop(title: String, message: String, sender: UIViewController) {
        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            alert.view.tintColor = UIColor(red: 0xCC, green: 0x5A, blue: 0x5A)
            sender.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
