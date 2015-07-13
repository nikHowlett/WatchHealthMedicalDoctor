//
//  SurveyNotificationSystemViewController.swift
//  mobile
//
//  Created by MAC-ATL019922 on 6/26/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SurveyNotificationSystemViewController: UIViewController {
        
        @IBOutlet weak var datePicker: UIDatePicker!
        
        @IBOutlet weak var howOftenPicker: UIDatePicker!
    
        @IBOutlet weak var csslol: UIButton!
        //@IBOutlet weak var cssolo: UIButton!
        
        @IBOutlet weak var cssolo: UIButton!
        //@IBOutlet weak var csslol: UIButton!
        
        @IBOutlet weak var watchimagelol: UIImageView!
        
        @IBOutlet weak var ntso: UILabel!
        
        @IBOutlet weak var label1: UILabel!
        
        @IBOutlet weak var label2: UILabel!
        
        @IBOutlet weak var pointless1: UILabel!
        
        @IBOutlet weak var pointfull1: UILabel!
        
        @IBOutlet weak var pointesl22: UILabel!
        
        @IBOutlet weak var send1: UIButton!
    
        @IBOutlet weak var pointless6: UILabel!
    
        @IBOutlet weak var pointless47: UILabel!

//      var data2sendlabel: String = ""
    
        var surveyList: NSMutableArray = []
    
        var data2sendlabel: String = ""
    
        lazy var managedObjectContext : NSManagedObjectContext? = {
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
            } else {
                return nil
            }
            }()
    
        var surveys : [Survey] = [Survey]()
    
        var surveyLines = [NSManagedObject]()
        
        func handleWatchKitNotification(notification: NSNotification) {
             if let userInfo = notification.object as? [String : String] {
                print("watchnot received/text updated")
                //if (userInfo["message"]!) {
                //    println("successfully caught sleepnotification")
                //} else {
                data2sendlabel = userInfo["message"]!
                //}
                //pointfull1.text = userInfo["message"]
                /*println("1")
                let tstamp = pointfull1.text!.substringToIndex(advance(pointfull1.text!.startIndex, 19))
                let surveydata = pointfull1.text!.substringFromIndex(advance(pointfull1.text!.startIndex,26))
                let newsurveydataitem: surveydatables = surveydatables(dataname: tstamp, result: surveydata)
                println("2")
                var stu = surveyList.count
                func handleWatchKitNotification(notification: NSNotification) {
                if let userInfo = notification.object as? [String : String] {
                println("watchnot received/text updated")
                data2sendlabel = userInfo["message"]!
                }
                var surveytimestampdata = data2sendlabel.substringToIndex(advance(data2sendlabel.startIndex, 19))
                var surveydatainfo = data2sendlabel.substringFromIndex(advance(data2sendlabel.startIndex,26))
                self.saveSurvey(surveytimestampdata, results: surveydatainfo)
                println("savingsurvey")
                }
                var jan = surveyd.count
                println("3")
                surveyd.insert((newsurveydataitem), atIndex: jan)
                surveyList.addObject(newsurveydataitem)
                println("4")
                saveSurveyList()
                println("5")*/
                //self.saveSurvey(pointfull1.text!)
            }
            /*scheduleLocalNotification()
            var nextNotification = UILocalNotification()
            //nextNotification.fireDate = fixNotificationDate(howOftenPicker.date)
            var seconds = howOftenPicker.countDownDuration
            print(seconds)
            nextNotification.fireDate = NSDate(timeIntervalSinceNow: seconds)
            nextNotification.category = "someCategory"
            nextNotification.alertTitle = "CheckUp Survey!"
            nextNotification.soundName = "beep-01a.wav"
            nextNotification.alertBody = "Doctor Jenkins says 'Take a UCB watch-app survey!'"
            nextNotification.alertAction = "JustWokeUp"
            UIApplication.sharedApplication().scheduleLocalNotification(nextNotification)
            */
            let localNotification = UILocalNotification()
            localNotification.soundName = "beep-01a.wav"
            localNotification.alertTitle = "Take your next survey!"
            localNotification.alertBody = "Doctor Jenkins says 'Take a UCB watch-app survey!'"
            localNotification.alertAction = "Take Survey"
            localNotification.category = "someCategory"
            
            let seconds = howOftenPicker.countDownDuration
            print(seconds, appendNewline: false)
            localNotification.fireDate = NSDate(timeIntervalSinceNow: seconds)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            let math: Int = data2sendlabel.characters.count
            if (math > 18) {
            let surveytimestampdata = data2sendlabel.substringToIndex(advance(data2sendlabel.startIndex, 19))
            let surveydatainfo = data2sendlabel.substringFromIndex(advance(data2sendlabel.startIndex,26))
            self.saveSurvey(surveytimestampdata, results: surveydatainfo)
            print("savingsurvey")
            }
        }
    
        
        /*func saveSurvey(name: String) {
            //1
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext!
            
            //2
            let entity =  NSEntityDescription.entityForName("SurveyData",
                inManagedObjectContext:
                managedContext)
            
            let simp = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:managedContext)
            
            //3
            let tstamp = name.substringToIndex(advance(name.startIndex, 19))
            let surveydata = name.substringFromIndex(advance(name.startIndex,26))
            simp.setValue(tstamp, forKey: "timeStamp")
            simp.setValue(surveydata, forKey: "results")
            
            //4
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            }
            //
            surveyLines.append(simp)
        }
    */
        private func saveSurvey(timeStamp: String, results: String) {
            if managedObjectContext != nil {
                let entity = NSEntityDescription.entityForName("Survey", inManagedObjectContext: managedObjectContext!)
                let survey = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!) as! mobile.Survey
                survey.timeStamp = timeStamp
                survey.results = results
            
                var error: NSError? = nil
                do {
                    try managedObjectContext!.save()
                    surveys.append(survey)
                } catch var error1 as NSError {
                    error = error1
                    print("Could not save \(error), \(error?.userInfo)")
                }
            } else {
                print("Could not get managed object context")
            }
        }
    
        @IBAction func ohmyshare(sender: AnyObject) {
            if (pointfull1.text == "Label") {
                let nextNotification = UILocalNotification()
                //nextNotification.fireDate = fixNotificationDate(howOftenPicker.date)
                //var seconds = howOftenPicker.countDownDuration
                //print(seconds)
                nextNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
                nextNotification.soundName = "beep-01a.wav"
                nextNotification.alertBody = "No survey data collected!"
                UIApplication.sharedApplication().scheduleLocalNotification(nextNotification)
            } else {
                let textToShare = "Hey Doctor Scott, my UCB 'Next-Gen-Med' app is sending you my latest survey data."
                let tstamp = pointfull1.text!.substringToIndex(advance(pointfull1.text!.startIndex, 19))
                let surveydata = pointfull1.text!.substringFromIndex(advance(pointfull1.text!.startIndex,26))
                if let myWebsite = pointfull1.text {
                    let objectsToShare = [tstamp, textToShare, surveydata]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                    
                    self.presentViewController(activityVC, animated: true, completion: nil)
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //self.view.backgroundColor = UIColor.blueColor()
            datePicker.hidden = true
            howOftenPicker.hidden = true
            //datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
            //howOftenPicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
            cssolo.hidden = true
            label1.hidden = true
            label2.hidden = true
            howOftenPicker.countDownDuration = 120.0;
            setupNotificationSettings()
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: nil))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
            // Do any additional setup after loading the view, typically from a nib.
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleTakeSurveyNotification"), name: "takeSurveyNotification", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleRemindMeNotification"), name: "remindMeNotification", object: nil)
            pointfull1.text = "Label"
            print("thishas")
        }
        
        func handleTakeSurveyNotification() {
            //txtAddItem.becomeFirstResponder()
            //add immediate notiication to trigger on watch
        }
    
        func handleRemindMeNotification() {
            let nextNotification = UILocalNotification()
            //nextNotification.fireDate = fixNotificationDate(howOftenPicker.date)
            let seconds = howOftenPicker.countDownDuration
            //print(seconds)
            nextNotification.fireDate = NSDate(timeIntervalSinceNow: 60 * seconds)
            nextNotification.soundName = "beep-01a.wav"
            nextNotification.alertBody = "Doctor Jenkins says 'Take a UCB watch-app survey!'"
            UIApplication.sharedApplication().scheduleLocalNotification(nextNotification)
        }
        
        @IBAction func configuresurveysettings(sender: AnyObject) {
            if datePicker.hidden {
                animateMyViews(ntso, viewToShow: datePicker)
                animateMyViews(pointless6, viewToShow: howOftenPicker)
                animateMyViews(pointless1, viewToShow: label1)
                animateMyViews(pointfull1, viewToShow: label2)
                animateMyViews(csslol, viewToShow: cssolo)
                animateMyViews(pointless47, viewToShow: pointesl22)
                //csslol.text = "Back"
                UIApplication.sharedApplication().cancelAllLocalNotifications()
            }
            else{
                animateMyViews(datePicker, viewToShow: ntso)
                animateMyViews(howOftenPicker, viewToShow: pointless6)
                animateMyViews(label1, viewToShow: pointless1)
                animateMyViews(label2, viewToShow: pointfull1)
                animateMyViews(cssolo, viewToShow: csslol)
                animateMyViews(pointesl22, viewToShow: pointless47)
                //scheduleLocalNotification()
                
            }
            
            //txtAddItem.enabled = !txtAddItem.enabled
        }
        
        @IBAction func savesurveysettings(sender: AnyObject) {
            animateMyViews(datePicker, viewToShow: ntso)
            animateMyViews(howOftenPicker, viewToShow: pointless6)
            animateMyViews(label1, viewToShow: pointless1)
            animateMyViews(label2, viewToShow: pointfull1)
            animateMyViews(cssolo, viewToShow: csslol)
            animateMyViews(pointless47, viewToShow: pointesl22)
            scheduleLocalNotification()
            //showNotificationFire()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func animateMyViews(viewToHide: UIView, viewToShow: UIView) {
            let animationDuration = 0.35
            
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                viewToHide.transform = CGAffineTransformScale(viewToHide.transform, 0.001, 0.001)
                }) { (completion) -> Void in
                    
                    viewToHide.hidden = true
                    viewToShow.hidden = false
                    
                    viewToShow.transform = CGAffineTransformScale(viewToShow.transform, 0.001, 0.001)
                    
                    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        viewToShow.transform = CGAffineTransformIdentity
                    })
            }
        }
        
        func scheduleLocalNotification() {
            //finish repeat fires
            //ohmygod I figured it out holy crap it just came to me
            //and it was so stressfull at first when I couldn't come up with it
            //and it seems obvious, but its always hard to come up
            //with a solution yourself
            //so exciting
            //that was worth 5000 dollars
            let localNotification = UILocalNotification()
            localNotification.soundName = "beep-01a.wav"
            localNotification.alertTitle = "Take your first survey of the day!"
            localNotification.alertBody = "Just respond on your Apple Watch to get started."
            localNotification.alertAction = "Take Survey"
            localNotification.category = "surveyReminderCategory"
            localNotification.fireDate = fixNotificationDate(datePicker.date)
            localNotification.repeatInterval = .Day
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            /*var nextNotification = UILocalNotification()
            //nextNotification.fireDate = fixNotificationDate(howOftenPicker.date)
            var seconds = howOftenPicker.countDownDuration
            print(seconds)
            nextNotification.fireDate = NSDate(timeIntervalSinceNow: seconds)
            nextNotification.soundName = "beep-01a.wav"
            nextNotification.alertBody = "Doctor Jenkins says 'Take a UCB watch-app survey!'"
            */
            //UIApplication.sharedApplication().scheduleLocalNotification(nextNotification)
            
        }
    
        func setupNotificationSettings() {
            let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
            
            if (notificationSettings.types == UIUserNotificationType.None){
                // Specify the notification types.
                var notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
                
                
                // Specify the notification actions.
                var remindMe = UIMutableUserNotificationAction()
                remindMe.identifier = "remindMe"
                remindMe.title = "Remind me in 5!"
                remindMe.activationMode = UIUserNotificationActivationMode.Background
                remindMe.destructive = false
                remindMe.authenticationRequired = true
                
                var takeSurvey = UIMutableUserNotificationAction()
                takeSurvey.identifier = "takeSurvey"
                takeSurvey.title = "Take Survey"
                takeSurvey.activationMode = UIUserNotificationActivationMode.Foreground
                takeSurvey.destructive = false
                takeSurvey.authenticationRequired = true
                
                var trashAction = UIMutableUserNotificationAction()
                trashAction.identifier = "trashAction"
                trashAction.title = "Ignore"
                trashAction.activationMode = UIUserNotificationActivationMode.Background
                trashAction.destructive = true
                trashAction.authenticationRequired = false
                
                let actionsArray = NSArray(objects: takeSurvey, remindMe, trashAction)
                let actionsArrayMinimal = NSArray(objects: remindMe, takeSurvey)
                
                // Specify the category related to the above actions.
                var surveyReminderCategory = UIMutableUserNotificationCategory()
                surveyReminderCategory.identifier = "surveyReminderCategory"
                /*surveyReminderCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
                surveyReminderCategory.setActions(actionsArrayMinimal as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)*/
                surveyReminderCategory.setActions(actionsArray as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
                surveyReminderCategory.setActions(actionsArrayMinimal as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
                
                
                let categoriesForSettings = NSSet(objects: surveyReminderCategory)
                
                
                // Register the notification settings.
                //let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as Set<NSObject> as Set<NSObject>)
                let newNotificationSettings = UIUserNotificationSettings(
                    forTypes: [.Alert, .Badge, .Sound],
                    categories: NSSet(objects: categoriesForSettings) as! Set<UIUserNotificationCategory>)
                //let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: NSSet(object: categoriesForSettings
                //) as Set<NSObject>)
                UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
            }
        }
        
        func fixNotificationDate(dateToFix: NSDate) -> NSDate {
            let dateComponets: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit], fromDate: dateToFix)
            
            dateComponets.second = 0
            
            let fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponets)
            
            return fixedDate
        }
        
        func saveSurveyList() {
            let pathsArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory = pathsArray[0] as String
            let savePath = documentsDirectory.stringByAppendingPathComponent("survey_list")
            surveyList.writeToFile(savePath, atomically: true)
        }
        
}

