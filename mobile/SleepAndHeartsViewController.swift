//
//  SleepAndHeartsViewController.swift
//  mobile
//
//  Created by MAC-ATL019922 on 6/25/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import CoreData


class SleepAndHeartsViewController: UIViewController {
        
        var healthStore: HKHealthStore?
        
        @IBOutlet weak var mrhr: UILabel!
        
        @IBOutlet weak var mrhrdate: UILabel!
        
        @IBOutlet weak var napstart: UILabel!
        
        @IBOutlet weak var napend: UILabel!
        
        @IBOutlet weak var sleepstart: UILabel!
        
        @IBOutlet weak var sleepend: UILabel!
        
        @IBOutlet weak var SlpQual: UILabel!
        
        var data2sendlabel: String = ""
        
        lazy var managedObjectContext : NSManagedObjectContext? = {
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
                return managedContext
            } else {
                return nil
            }
            }()
        
        //var surveys : [Survey] = [Survey]()
    
        var sleeps : [SleepHistoryObject] = [SleepHistoryObject]()
        
        func handleWatchKitNotification(notification: NSNotification) {
            if let userInfo = notification.object as? [String : Int] {
                print("sleep received/text updated")
                let someint = userInfo["sleep massage"]!
                let somestring = "\(someint)"
                data2sendlabel = somestring
            }
            let thisstart = sleepstart.text?.substringToIndex(advance(sleepstart.text!.startIndex, 19))
            let thisend = sleepend.text?.substringToIndex(advance(sleepend.text!.startIndex, 19))
            let temp1 : String! = data2sendlabel
            SlpQual.text = temp1
            let shanty = self.sleepstart.text
            let thisstart2 = shanty!.substringToIndex(advance(shanty!.startIndex, 19))
            //println(thisstart)
            let lastsleepstart = self.sleeps[self.sleeps.count-1].sleepStart
            //println(lastsleepstart)
            if (thisstart == lastsleepstart) || (thisstart2 == lastsleepstart) {
                //self.SlpQual.text = self.sleeps[self.sleeps.count-1].sleepQuality
                //sleeps.removeAtIndex(sleeps.count-1)
                managedObjectContext?.deleteObject(sleeps[sleeps.count-1] as SleepHistoryObject)
                
                var error: NSError? = nil
                do {
                    try managedObjectContext!.save()
                    sleeps.removeAtIndex(self.sleeps.count-1)
                } catch var error1 as NSError {
                    error = error1
                    print("Failed to delete the item \(error), \(error?.userInfo)")
                }
            }
            self.saveSleep(thisstart!, sleepEnd: thisend!, sleepQuality: data2sendlabel)
            print(data2sendlabel)
            print("savingSLEEPsurvey \(data2sendlabel)")
        }
    
        private func saveSleep(sleepStart: String, sleepEnd: String, sleepQuality: String) {
            if managedObjectContext != nil {
                let entity = NSEntityDescription.entityForName("SleepHistoryObject", inManagedObjectContext: managedObjectContext!)
            //@objc(sleep)
            let sleep = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!) as! mobile.SleepHistoryObject
            sleep.sleepStart = sleepStart
            sleep.sleepEnd = sleepEnd
            sleep.sleepQuality = sleepQuality
            
            var error: NSError? = nil
            do {
                try managedObjectContext!.save()
                //names.append(name)
            } catch var error1 as NSError {
                error = error1
                print("Could not save \(error), \(error?.userInfo)")
            }
            } else {
                print("Could not get managed object context")
            }
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            /*UIApplication.sharedApplication().registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes:UIUserNotificationType.Sound | UIUserNotificationType.Alert,
                    categories: nil))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
`           */
            
            self.navigationItem.title = "Heart-Rate Analysis"
            refresh()
            let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "SleepHistoryObject")
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: nil))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
            let error: NSError? = nil
            do { sleeps = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [SleepHistoryObject] } catch let error as NSError { print("An error occurred loading the data") }
            //sleeps.removeAtIndex(self.sleeps.count-1)
            if error != nil {
                print("An error occurred loading the data")
            }
            
        }
        
        @IBAction func rfrsh(sender: AnyObject) {
            refresh()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        func refresh() {
            updateHeartRate()
            updateSHeartRate()
            updateNapRate()
            updateSleepRate()
        }
        
        func updateHeartRate() {
            let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            readMostRecentSample(sampleType!, completion: { (mostRecentHeartRate, error) -> Void in
                if error != nil {
                    print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                
                let heartRate = mostRecentHeartRate as? HKQuantitySample
                let bpm = heartRate?.quantity.doubleValueForUnit(HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit()))
                
                print("bpm=\(bpm)")
                
                // 4. Update UI in the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if bpm != nil {
                        self.mrhr.text = "\(Int(bpm!))"
                    } else {
                        self.mrhr.text = "?"
                    }
                });
            });
        }
        
        func updateSHeartRate() {
            let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            readMostRecentSample(sampleType!, completion: { (mostRecentHeartRate, error) -> Void in
                if error != nil {
                    print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                
                let heartRate = mostRecentHeartRate.startDate
                let funk = mostRecentHeartRate.startDate
                
                // 4. Update UI in the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //self.happiness = Int(self.bpmToHappiness(bpm))
                    //println("self.happiness=\(self.happiness)")
                    if heartRate == funk {
                        self.mrhrdate.text = "\(heartRate)"
                    } else {
                        self.mrhrdate.text = "?"
                    }
                });
            });
        }
        
        
        func updateNapRate() {
            let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            // 2. Call the method to read the most recent weight sample
            readMostRecentNapStart(sampleType!, completion: { (mostRecentwakeupfromnapRate, error) -> Void in
                if error != nil {
                    print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                
                
                let heartRate = mostRecentwakeupfromnapRate.startDate
                let fartRate = mostRecentwakeupfromnapRate.startDate
                
                // 4. Update UI in the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if heartRate == fartRate {
                        self.napstart.text = "\(heartRate)"
                    } else {
                        self.napstart.text = "?"
                    }
                });
            });
            
            readMostRecentNapEnd(sampleType!, completion: { (mostRecentwakeupfromnapRate, error) -> Void in
                if error != nil {
                    print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                
                let faghlom = mostRecentwakeupfromnapRate.startDate
                let insanity = mostRecentwakeupfromnapRate.startDate
                
                // 4. Update UI in the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if faghlom == insanity {
                        self.napend.text = "\(faghlom)"
                    } else {
                        self.napend.text = "?"
                    }
                });
            });
            
        }
        
        private func readMostRecentSample(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
            // 1. Build the Predicate
            let past = NSDate.distantPast() as NSDate
            let now = NSDate()
            let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
            
            // 2. Build the sort descriptor to return the samples in descending order
            let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
            // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
            let limit = 1
            
            // 4. Build samples query
            let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor], resultsHandler: { (sampleQuery, results, error ) -> Void in
                if let queryError = error {
                    completion(nil,error)
                    return
                }
                
                // Get the first sample
                let mostRecentSample = results!.first as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample, nil)
                }
            })
            // 5. Execute the Query
            healthStore!.executeQuery(sampleQuery)
        }
        
        func updateSleepRate() {
            let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            
            // 2. Call the method to read the most recent weight sample
            readMostRecentSLPStart(sampleType!, completion: { (mostRecentwakeupfromnapRate, error) -> Void in
                if error != nil {
                    print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                
                
                let heartRate = mostRecentwakeupfromnapRate.startDate
                let notHeartRate = mostRecentwakeupfromnapRate.startDate
                
                // 4. Update UI in the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if heartRate == notHeartRate {
                        self.sleepstart.text = "\(heartRate)"
                        var shanty = self.sleepstart.text
                        //var thisstart2 = shanty?.substringToIndex(advance(shanty!.startIndex, 19, shanty!.endIndex))
                        //var thisstart = sleepstart.text?.substringToIndex(advance(sleepstart.text!.startIndex, 19, sleepstart.text?.))
                        var thisstart = shanty!.substringToIndex(advance(shanty!.startIndex, 19))
                        //println(thisstart)
                        var lastsleepstart = self.sleeps[self.sleeps.count-1].sleepStart
                        //println(lastsleepstart)
                        if (thisstart == lastsleepstart) {
                            self.SlpQual.text = self.sleeps[self.sleeps.count-1].sleepQuality
                        } else {
                            let alertController = UIAlertController(title: "SleepQuality", message:
                                "Most recent sleep data has no SleepQuality attribute. Please enter this information.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                            //}
                        }
                    } else {
                        self.sleepstart.text = "?"
                    }
                });
            });
            /*if (sleeps.isEmpty) || (sleepstart.text == "?") || (sleepstart.text == "StartTime") {
                println("nosleepdata")
            } else {
                println("ok imma try to load the quality")*/
            
            readMostRecentSLPEnd(sampleType!, completion: { (mostRecentwakeupfromnapRate, error) -> Void in
                if error != nil {
                    print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                
                let faghlom = mostRecentwakeupfromnapRate.startDate
                let jghlom = mostRecentwakeupfromnapRate.startDate
                
                // 4. Update UI in the main thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if faghlom == jghlom {
                        self.sleepend.text = "\(faghlom)"
                    } else {
                        self.sleepend.text = "?"
                    }
                });
            });
            
        }
        
        private func readMostRecentNapStart(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
            let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
            let now = NSDate()
            let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate:now, options: .None)
            
            // 2. Build the sort descriptor to return the samples in descending order
            let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
            let limit = 1000
            
            // 4. Build samples query
            let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor], resultsHandler: { (sampleQuery, results, error ) -> Void in
                if let queryError = error {
                    completion(nil,error)
                    return
                }
                let totalsamp = results!.count
                var jk: Int = 0
                var impda: NSDate = NSDate()
                var nap: String
                var naptime: String
                var boooool: Bool = (jk < totalsamp)
                while (boooool) {
                    var thisstep: AnyObject = results![jk]
                    var nextstep: AnyObject = results![jk+1]
                    //let differenceComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: thisstep.startDate, toDate: nextstep.startDate, options: NSCalendarOptions(0) )
                    var shoodate: NSDate = (thisstep.startDate)
                    var slambam: NSDate = (nextstep.startDate)
                    var age = ((shoodate.timeIntervalSinceDate(slambam)) / 60)
                    //.timeIntervalSinceDate(nextstep.startDate)
                    //var age: Int? = differenceComponents.minute
                    print(age)
                    //this next number (integer i think) controls how long the "nap/sleep" is
                    if (age < 30 || age > 180) {
                        print(age)
                        jk++
                    } else {
                        print("final")
                        print("number value is: \(jk)")
                        boooool = false
                        //impda = thisstep
                    }
                }
                print("number value is: \(jk)")
                
                // Get the first sample
                let mostRecentSample = results![jk] as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample, nil)
                }
            })
            // 5. Execute the Query
            healthStore!.executeQuery(sampleQuery)
        }
        
        private func readMostRecentSLPStart(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
            let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
            let now = NSDate()
            let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate:now, options: .None)
            
            // 2. Build the sort descriptor to return the samples in descending order
            let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
            let limit = 1000
            
            // 4. Build samples query
            let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor], resultsHandler: { (sampleQuery, results, error ) -> Void in
                if let queryError = error {
                    completion(nil,error)
                    return
                }
                let totalsamp = results!.count
                var jk: Int = 0
                var impda: NSDate = NSDate()
                var nap: String
                var naptime: String
                var boooool: Bool = (jk < totalsamp)
                while (boooool) {
                    var thisstep: AnyObject = results![jk]
                    var nextstep: AnyObject = results![jk+1]
                    //let differenceComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: thisstep.startDate, toDate: nextstep.startDate, options: NSCalendarOptions(0) )
                    var shoodate: NSDate = (thisstep.startDate)
                    var slambam: NSDate = (nextstep.startDate)
                    var age = ((shoodate.timeIntervalSinceDate(slambam)) / 60)
                    //.timeIntervalSinceDate(nextstep.startDate)
                    //var age: Int? = differenceComponents.minute
                    print(age)
                    //this next number (integer i think) controls how long the "nap/sleep" is
                    if (age < 180) {
                        print(age)
                        jk++
                    } else {
                        print("final")
                        print("number value is: \(jk)")
                        boooool = false
                        //impda = thisstep
                    }
                }
                print("number value is: \(jk)")
                
                // Get the first sample
                let mostRecentSample = results![jk] as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample, nil)
                }
            })
            // 5. Execute the Query
            healthStore!.executeQuery(sampleQuery)
        }
        
        private func readMostRecentNapEnd(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
            let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
            let now = NSDate()
            let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate:now, options: .None)
            
            // 2. Build the sort descriptor to return the samples in descending order
            let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
            let limit = 1000
            
            // 4. Build samples query
            let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor], resultsHandler: { (sampleQuery, results, error ) -> Void in
                if let queryError = error {
                    completion(nil,error)
                    return
                }
                let totalsamp = results!.count
                var jk: Int = 0
                var impda: NSDate = NSDate()
                var nap: String
                var naptime: String
                var boooool: Bool = (jk < totalsamp)
                while (boooool) {
                    var thisstep: AnyObject = results![jk]
                    var nextstep: AnyObject = results![jk+1]
                    //let differenceComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: thisstep.startDate, toDate: nextstep.startDate, options: NSCalendarOptions(0) )
                    var shoodate: NSDate = (thisstep.startDate)
                    var slambam: NSDate = (nextstep.startDate)
                    var age = ((shoodate.timeIntervalSinceDate(slambam)) / 60)
                    //.timeIntervalSinceDate(nextstep.startDate)
                    //var age: Int? = differenceComponents.minute
                    print(age)
                    if (age < 30 || age > 180) {
                        print(age)
                        jk++
                    } else {
                        print("final")
                        print("number value is: \(jk)")
                        boooool = false
                        //impda = thisstep
                    }
                }
                print("number value is: \(jk)")
                
                // Get the first sample
                let mostRecentSample = results![jk+1] as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample, nil)
                }
            })
            // 5. Execute the Query
            healthStore!.executeQuery(sampleQuery)
        }
        
        private func readMostRecentSLPEnd(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
            let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -3, toDate: NSDate(), options: [])
            let now = NSDate()
            let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(yesterday, endDate:now, options: .None)
            
            // 2. Build the sort descriptor to return the samples in descending order
            let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
            let limit = 1000
            
            // 4. Build samples query
            let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor], resultsHandler: { (sampleQuery, results, error ) -> Void in
                if let queryError = error {
                    completion(nil,error)
                    return
                }
                let totalsamp = results!.count
                var jk: Int = 0
                var impda: NSDate = NSDate()
                var nap: String
                var naptime: String
                var boooool: Bool = (jk < totalsamp)
                while (boooool) {
                    var thisstep: AnyObject = results![jk]
                    var nextstep: AnyObject = results![jk+1]
                    //let differenceComponents = NSCalendar.currentCalendar().components(.CalendarUnitYear, fromDate: thisstep.startDate, toDate: nextstep.startDate, options: NSCalendarOptions(0) )
                    var shoodate: NSDate = (thisstep.startDate)
                    var slambam: NSDate = (nextstep.startDate)
                    var age = ((shoodate.timeIntervalSinceDate(slambam)) / 60)
                    //.timeIntervalSinceDate(nextstep.startDate)
                    //var age: Int? = differenceComponents.minute
                    print(age)
                    if (age < 180) {
                        print(age)
                        jk++
                    } else {
                        print("final")
                        print("number value is: \(jk)")
                        boooool = false
                        //impda = thisstep
                    }
                }
                print("number value is: \(jk)")
                
                // Get the first sample
                let mostRecentSample = results![jk+1] as? HKQuantitySample
                
                // Execute the completion closure
                if completion != nil {
                    completion(mostRecentSample, nil)
                }
            })
            // 5. Execute the Query
            healthStore!.executeQuery(sampleQuery)
        }
        
    }
