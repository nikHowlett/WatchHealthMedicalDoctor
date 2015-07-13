//
//  HowSleepyInterfaceController.swift
//  mobile
//
//  Created by MAC-ATL019922 on 6/25/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation


class HowSleepyInterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        /*var userInfo = [
            "scheduleLocalNotification": true,
            "category": "someCategory",
            "alertTitle": "How was your sleep:",
            "alertBody": "How was your sleep",
            "fireDate": NSDate(timeIntervalSinceNow: 6),
            "applicationIconBadgeNumber": 1,
            "soundName": UILocalNotificationDefaultSoundName
        ]
        
        // Register notifications in iOS
        WKInterfaceController.openParentApplication(userInfo) {
            (replyInfo, error) -> Void in
            // Callback here if needed
        }
        */
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
