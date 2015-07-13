//
//  f.swift
//  tablesdatasettingshistoryinfo
//
//  Created by MAC-ATL019922 on 6/22/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import CoreData

class detail: UIViewController, MFMailComposeViewControllerDelegate
{
    // Model
    var sleepitem: SleepHistoryObject?
    
    //@IBOutlet weak var LABEL: UILabel!
    @IBOutlet weak var LABEL: UILabel!
    @IBOutlet weak var WU: UILabel!
    @IBOutlet weak var SQ: UILabel!

    //@IBOutlet weak var WU: UILabel!
    
    //@IBOutlet weak var SQ: UILabel!
    
    var dox : [Doctor] = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LABEL.text = sleepitem?.sleepStart
        WU.text = sleepitem?.sleepEnd
        SQ.text = sleepitem?.sleepQuality
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Doctor")
        let error: NSError? = nil
        do { dox = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [Doctor] } catch let error as NSError { print("An error occurred loading the data") }
        if error != nil {
            print("An error occurred loading the data")
        }
    }
    
    @IBAction func tare(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let resip = [dox[dox.count-1].email]
        mailComposerVC.setToRecipients(resip)
        mailComposerVC.setSubject("Sleep/Health Survey auto-results")
        let jenkins = "Thank goodness I can automatically send you updates on how I am doing thanks to the UCB Pharma development team. My sleep/nap started at \(sleepitem!.sleepStart) and ended at \(sleepitem!.sleepEnd). On a scale from one to ten, I would rate the quality of my sleep as \(sleepitem!.sleepQuality)."
        mailComposerVC.setMessageBody("\(jenkins)", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()

}
