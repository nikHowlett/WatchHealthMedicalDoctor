//
//  SleepScaleInterfaceController.swift
//  nikdeployer
//
//  Created by MAC-ATL019922 on 6/11/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation


class SleepScaleInterfaceController: WKInterfaceController {

    var painnumber = 4
    var janet = "Tiredness: 5"
    var Nub = 1
    
    //@IBOutlet weak var painlabel: WKInterfaceLabel!
    
    @IBOutlet weak var painlabel: WKInterfaceLabel!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        //if let diang = context as? sendables {
        //  println("this worked \(diang.dataName)")
        //}
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    @IBAction func sendthatshit() {
        let date = NSDate()
        let vrun = "I would say I am \(Nub) out of ten tired."
        let total = "\(date) \(janet)"
        let dict: Dictionary = ["message": total]
        print("datahasbeensent", appendNewline: false)
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
    }
    /*
    @IBAction func SubmitData() {
    var imcompilingshit = "\(date) \(michaelnorris)"
    let dict: Dictionary = ["message": imcompilingshit]
    WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in println("Data has been sent to target: parent iOS app - UCB Pharma")
    })
    }
    */
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
    /*@IBAction func painslider(value: Float) {
        Nub = Int(value * 1)
        janet = "Tiredness: \(Nub)"
        painlabel.setText
    //this is a test(janet)
    }
    */
    
    
    @IBAction func painslider(value: Float) {
        Nub = Int(value * 1)
        janet = "Tiredness: \(Nub)"
        painlabel.setText(janet)
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        /*if segueIdentifier == "sch" {
            println("the pain has been sent")
            return sendables(dataname: "I would say I am \(Nub) out of ten tired.")
        }*/
        let date = NSDate()
        let vrun = "I would say I am \(Nub) out of ten tired."
        let total = "\(date) \(janet)"
        let dict: Dictionary = ["message": total]
        print("datahasbeensent", appendNewline: false)
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
        //println("the pain has not been sent!")
        return sendables(dataname: "I am not experiencing any pain currently.")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
