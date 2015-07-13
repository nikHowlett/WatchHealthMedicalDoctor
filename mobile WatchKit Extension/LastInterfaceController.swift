//
//  LastInterfaceController.swift
//  mobile
//
//  Created by MAC-ATL019922 on 6/30/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation


class LastInterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        let userInfo = [
            "justWokeUp": true,
            "sleepQualData": "someCategory"
        ]
        
        // Register notifications in iOS
        WKInterfaceController.openParentApplication(userInfo) {
            (replyInfo, error) -> Void in
            // Callback here if needed                
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
