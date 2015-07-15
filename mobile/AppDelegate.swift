//
//  AppDelegate.swift
//  mobile
//
//  Created by MAC-ATL019922 on 6/25/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: ([NSObject : AnyObject]?) -> Void) {
        NSNotificationCenter.defaultCenter().postNotificationName("WatchKitReq", object: userInfo)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var navigationBarAppearace = UINavigationBar.appearance()
        //UINavigationBar.appearance().barTintColor = UIColor(hex: 0x062134)
        //navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        /*navigationBarAppearace.tintColor = uicolorFromHex(0x062134)
        
        
        navigationBarAppearace.tintColor = uicolorFromHex(0xffffff)
        navigationBarAppearace.barTintColor = uicolorFromHex(0x034517)
        */
        navigationBarAppearace.tintColor = uicolorFromHex(0xFFFFFF)
        //ucb logo blue code 073190
        //ucb medical videos blue code 062134
        navigationBarAppearace.barTintColor = uicolorFromHex(0x062134)
        
        UITabBar.appearance().barTintColor = uicolorFromHex(0x062134)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        var snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "heartRateWake"
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = .Background
        snoozeAction.destructive = false
        snoozeAction.authenticationRequired = false
        
        // Notification category
        var mainCategory = UIMutableUserNotificationCategory()
        mainCategory.identifier = "heartRateWake"
        
        let defaultActions = [snoozeAction]
        let minimalActions = [snoozeAction]
        
        mainCategory.setActions(defaultActions, forContext: .Default)
        mainCategory.setActions(minimalActions, forContext: .Minimal)
        
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
        surveyReminderCategory.setActions(defaultActions, forContext: UIUserNotificationActionContext.Default)
        surveyReminderCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        var someCategory = UIMutableUserNotificationCategory()
        someCategory.identifier = "someCategory"
        someCategory.setActions(defaultActions, forContext: UIUserNotificationActionContext.Default)
        someCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        let categoriesForSettings = NSSet(objects: surveyReminderCategory)
        
        // Configure notifications
        /*let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Alert, .Badge, .Sound],
            categories: NSSet(objects: mainCategory, categoriesForSettings, someCategory) as Set<NSObject>)*/
        /*
        // categories may be nil or an empty set if custom user notification actions will not be used
        convenience init(forTypes types: UIUserNotificationType, categories: Set<UIUserNotificationCategory>?)
        // instances of UIUserNotificationCategory
        
        var types: UIUserNotificationType { get }
        
        // The set of UIUserNotificationCategory objects that describe the actions to show when a user notification is presented
        var categories: Set<UIUserNotificationCategory>? { get }
        */
        //UIUserNotificationType
        var Badje: UIUserNotificationType
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound],
            categories: NSSet(objects: mainCategory, categoriesForSettings, someCategory) as! Set<UIUserNotificationCategory>)
        /* init(forTypes types: UIUserNotificationType, categories: Set<UIUserNotificationCategory>?)
        */
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Alert, .Badge, .Sound],
            categories: NSSet(objects: mainCategory, categoriesForSettings, someCategory) as! Set<UIUserNotificationCategory>)
        
        // Register notifications
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        self.authorizeHealthKit { (authorized,  error) -> Void in
        if authorized {
            print("HealthKit authorization received.")
        } else {
            print("HealthKit authorization denied!")
            if error != nil {
                print("\(error)")
            }
        }
        }
        
        return true
    }
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    let healthStore:HKHealthStore = HKHealthStore()
    
    func startObservingHRChanges() {
    
        let sampleType =  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
    
        //var query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.heartRateChangedHandler)
        //var query: HKObserverQuery = HKObserverQuery(sampleType: <#T##HKSampleType#>, predicate: <#T##NSPredicate?#>, updateHandler: <#T##(HKObserverQuery, HKObserverQueryCompletionHandler, NSError?) -> Void#>)
        //(sampleType: HKSampleType, predicate: NSPredicate?, updateHandler: (HKObserverQuery, HKObserverQueryCompletionHandler, NSError?) -> Void)
        //let query = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: {(query: HKObserverQuery!, complete: HKObserverQueryCompletionHandler!, error: NSError!) -> Void in
            //handler(complete!, error)
        //})
        let query = HKObserverQuery(sampleType: sampleType!, predicate: nil) { (query, completionHandler, error) -> Void in
            NSLog("HelthKit Oberserver fired.....")
            if (error == nil) {
                //self.refreshData()
            }
            
        }
        healthKitStore.executeQuery(query)
        /*
        healthStore.enableBackgroundDeliveryForType(weightQuantityType,
        frequency: HKUpdateFrequency.Immediate) { (succeeded:Bool, error:NSError!) -> Void in
        if succeeded{
        println("Enabled background delivery of weight changes")
        }else{
        if let theError = error{
        print("Failed to enabled background changes")
        println("Error \(theError)")
        }
        }
        }
        */
        /*healthKitStore.enableBackgroundDeliveryForType(sampleType!, frequency: HKUpdateFrequency.Immediate, withCompletion: {(succeeded: Bool, error: NSError!) in
    
            if succeeded{
                print("Enabled background delivery of heart rate changes")
            } else {
                if let theError = error{
                print("Failed to enable background delivery of heart rate changes. ", appendNewline: false)
                print("Error = \(theError)")
                }
            }
        })*/
        healthKitStore.enableBackgroundDeliveryForType(sampleType!,
            frequency: .Immediate,
            withCompletion: {succeeded, error in
                
                if succeeded{
                    print("Enabled background delivery of weight changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery of heart rate changes. ")
                        print("Error = \(theError)")
                    }
                }
                
        })
    }
    
    
    func heartRateChangedHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: NSError!) {
        var wakeUpString : String = ""
        var thisTimeString: String = "l"
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        readMostRecentNapEnd(sampleType!, completion: { (mostRecentwakeupfromnapRate, error) -> Void in
            if error != nil {
                print("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                return
            }
            var wakeUpTime = mostRecentwakeupfromnapRate.startDate
            let past = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Minute, value: -10, toDate: NSDate(), options: [])
            print("10 minz ago \(past)")
            print("wakeupTime \(wakeUpTime)")
            var age = ((wakeUpTime.timeIntervalSinceDate(past!)) / 60)
            //.timeIntervalSinceDate(nextstep.startDate)
            //var age: Int? = differenceComponents.minute
            print(age)
            if (age > 0 || age == 0) {
                var notification = UILocalNotification()
                notification.alertBody = "Just woke up? How was it?"
                notification.alertAction = "Tell us!"
                notification.fireDate = NSDate(timeIntervalSinceNow: 10)
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                print("Notification has been scheduled due to heart rate and wake up matching")
            } else {
                print("wake up was not recent enough to schedule notification")
            }
        });

        completionHandler()
    }
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!) {
    
        // 1. Set the types you want to read from HK Store
        /*let healthKitTypesToRead: [HKQuantityType] = [HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth),
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType),
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight),
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        ]*/
        let healthKitTypesToRead: HKObjectType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
    
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!
            //HKQuantityType.workoutType()!
    
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "any.domain.com", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
    
            if( completion != nil ) {
                completion(success:false, error:error)
            }
        return;
    }
    
        healthKitStore.requestAuthorizationToShareTypes(Set(arrayLiteral: healthKitTypesToWrite), readTypes: Set(arrayLiteral: healthKitTypesToRead)) { (success, error) -> Void in
            if( completion != nil ) {
    
                dispatch_async(dispatch_get_main_queue(), self.startObservingHRChanges)
                completion(success:success,error:error)
            }
        }
    }



    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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
                if (age < 30) {
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
        healthStore.executeQuery(sampleQuery)
    }
    
    private func readMostRecentSample(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
        // 1. Build the Predicate
        //let past = NSDate.distantPast() as! NSDate
        let past = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
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
        healthStore.executeQuery(sampleQuery)
    }
    
    /*
    private func readPastTenMinSample(sampleType: HKSampleType, completion: ((HKSample!, NSError!) -> Void)!) {
        // 1. Build the Predicate
        let past = NSDate.distantPast() as! NSDate
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
            let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
            self.readMostRecentNapEnd(sampleType, completion: { (mostRecentwakeupfromnapRate, error) -> Void in
                if error != nil {
                    println("Error reading HeartRate from HealthKit Store: \(error.localizedDescription)")
                    return
                }
                var wakeUpTime = mostRecentwakeupfromnapRate.startDate
                let wakeUpString = "\(wakeUpTime)"
            });
            
            let resultscount = results.count
            var j = 0
            var thesesamples = []
            var hopefullyMatchingSample = results.first as? HKQuantitySample
            var jenny = false
            while (j < resultscount) {
                hopefullyMatchingSample = results[j] as? HKQuantitySample
                var startString = hopefullyMatchingSample!.startDate
                j = j + 1
                if (startString == wakeUpString) {
                    
                }
            }
            
            
            // Execute the completion closure
            if completion != nil {
                completion(hopefullyMatchingSample, nil)
            }
        })
        // 5. Execute the Query
        healthStore.executeQuery(sampleQuery)
    }
    */

    //var healthStore: HKHealthStore?
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ucb.apps.dev.mobile" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("mobile", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("mobile.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if self.managedObjectContext!.hasChanges {
            do {
                try managedObjectContext!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    /* SWIFT 1.2 func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                if moc.save()  {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    print("damnit")
                } else {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    } */

}

