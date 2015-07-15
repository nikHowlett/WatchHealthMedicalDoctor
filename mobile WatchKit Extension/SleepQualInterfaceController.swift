//
//  SleepQualInterfaceController.swift
//  tablesdatasettingshistoryinfo
//
//  Created by MAC-ATL019922 on 6/25/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import WatchKit
import Foundation


class SleepQualInterfaceController: WKInterfaceController {

    var sleepQual = 5
    var sqLabelText = "Quality: 5"
    var sliderValue = 1
    
    //@IBOutlet weak var sqLabel: WKInterfaceLabel!
    @IBOutlet weak var sqLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    
    @IBAction func sleepSliderDidMove(value: Float) {
        sliderValue = Int(value)
        sqLabelText = "Quality: \(sliderValue)"
        sqLabel.setText(sqLabelText)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        /*if segueIdentifier == "shc" {
            println("the pain has been sent")
            return sendables(dataname: "I would say I am \(sliderValue) out of ten tired.")
        }*/
        let total = "\(sqLabelText)"
        let dict: Dictionary = ["sleep massage": sliderValue]
        print(sliderValue)
        var userInfo = ["justWokeUp": true,
        "message": total]
        print("dataisbeensent", appendNewline: false)
        //WKInterfaceController.openParentApplication(userInfo as [NSObject : AnyObject]) {
        //    (replyInfo, error) -> Void in println("ok trying watch notification style #2")
        //}
        WKInterfaceController.openParentApplication(dict, reply: {(reply, error) -> Void in print("Data has been sent to target: parent iOS app - UCB Pharma", appendNewline: false)
        })
        print("the sleep is seeping into the sleet", appendNewline: false)
        return sendables(dataname: "My sleep quality could be described as \(sliderValue) out of 10.")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
