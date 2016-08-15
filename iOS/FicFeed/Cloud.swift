//
//  Cloud.swift
//  FicFeed
//
//  Created by Michelle Ran on 8/5/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging

public class Cloud {
    private static var deviceToken: String!
    private static var ref: FIRDatabaseReference!
    private static var deviceRef: FIRDatabaseReference!
    
    public static var subscribed: [Int] = []
    
    public static func setup(token: String) {
        deviceToken = token
        ref = FIRDatabase.database().reference()
        deviceRef = ref.child("devices/\(deviceToken)")
        getSubscribedTags { (subscribed: [Int]) in }
    }
    
    private static func getValueAtPath(path: String, completion: (AnyObject?) -> ()) {
        ref.child(path).observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
            completion(snapshot.value)
        }
    }
    
    public static func subscribeTo(tagId: Int) {
        getSubscribedTags { (subscribed: [Int]) in
            if !subscribed.contains(tagId) {
                self.subscribed.append(tagId)
                deviceRef.setValue(self.subscribed)
                FIRMessaging.messaging().subscribeToTopic("/topics/\(tagId)")
            }
        }
    }
    
    public static func unsubscribeFrom(tagId: Int) {
        getSubscribedTags { (subscribed: [Int]) in
            if let index = subscribed.indexOf(tagId) { // should contain, but just to be sure
                self.subscribed.removeAtIndex(index)
                deviceRef.setValue(self.subscribed)
                FIRMessaging.messaging().unsubscribeFromTopic("/topics/\(tagId)")
            }
        }
    }
    
    public static func getSubscribedTags(completion: ([Int]) -> ()) {
        if subscribed.count != 0 {
            completion(subscribed)
        } else {
            deviceRef.observeSingleEventOfType(.Value) { (snapshot: FIRDataSnapshot) in
                if let value = snapshot.value as? [Int] {
                    self.subscribed = value
                    completion(self.subscribed)
                } else {
                    completion([])
                }
            }
        }
    }
}
