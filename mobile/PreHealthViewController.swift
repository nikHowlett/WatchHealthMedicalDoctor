//
//  PreHealthViewController.swift
//  mobile
//
//  Created by MAC-ATL019922 on 6/25/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import HealthKit

class PreHealthViewController: UIViewController {
        
        let healthStore = HKHealthStore()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            authorizeHealthKit { (authorized,  error) -> Void in
                if authorized {
                    print("HealthKit authorization received.")
                    self.performSegueWithIdentifier("heartRateDisplay", sender: self)
                }
                else {
                    print("HealthKit authorization denied!")
                    if error != nil {
                        print("\(error)")
                    }
                }
            }
        }
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "heartRateDisplay" {
                
                if let happinessViewController = segue.destinationViewController as? SleepAndHeartsViewController {
                    happinessViewController.healthStore = healthStore
                }
                
            }
        }
        
        func autorizationComplete(success: Bool,  error: NSError?) -> Void {
            if success {
                print("HealthKit authorization received.")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.performSegueWithIdentifier("heartRateDisplay", sender: self)
                })
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
        
    let HK_Store = HKHealthStore()
    let healthDataToWrite : Set<HKQuantityType> = Set()
    let healthDatatoRead: Set<HKQuantityType> = Set(arrayLiteral: HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!)
    
    var authorizationReceived : Bool = false
    
    //MARK: Authorization
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        if !HKHealthStore.isHealthDataAvailable() {
            authorizationReceived = false
            let error = NSError(domain: "com.greci.MatthewGreci", code: 1, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available on this Device"])
            if (completion != nil) {
                completion(success:false, error:error)
            }
            return;
        }
        
        HK_Store.requestAuthorizationToShareTypes(healthDataToWrite, readTypes: healthDatatoRead) { (success, error) -> Void in
            if (completion != nil) {
                completion(success:success,error:error)
                self.authorizationReceived = true
            }
        }
}
        /*func authorizeHealthKit(completion: ((success: Bool, error:NSError!) -> Void)!) {
            //let healthKitTypesToRead: [HKObjectType] = [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)]
            
            let healthkitTypesToRead = NSSet(array: [
                // Each type we need access to is going to be an HKObjectType.
                // Here is are getting the Sex, BloodType and StepCount information.
                HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex),
                HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBloodType),
                HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth),
                HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount),
                ])
            // 2. Set the types you want to write to HK Store
            let healthKitTypesToWrite: [HKObjectType] = [
                /*HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)*/
            ]
            
            // 3. If the store is not available (for instance, iPad) return an error and don't go on.
            if !HKHealthStore.isHealthDataAvailable() {
                let error = NSError(domain: "han.ica.mad.HealthKitWorkshop", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
                autorizationComplete(false, error:error)
                return;
            }
            
            // 4.  Request HealthKit authorization
            /*SWIFT 2.0
            
            func requestAuthorizationToShareTypes(_ typesToShare: Set<HKSampleType>?,
            readTypes typesToRead: Set<HKObjectType>?,
            completion completion: (Bool,
            NSError?) -> Void)
            
            healthStore.requestAuthorizationToShareTypes(nil,
            readTypes: types,
            completion: {succeeded, error in
            
            if succeeded && error == nil{
            dispatch_async(dispatch_get_main_queue(),
            self.startObservingWeightChanges)
            } else {
            if let theError = error{
            print("Error occurred = \(theError)")
            }
            }
            
            })
            */
            //healthStore.requestAuthorizationToShareTypes(Set(healthKitTypesToWrite), readTypes: Set(healthKitTypesToRead), completion: autorizationComplete)
            healthStore.requestAuthorizationToShareTypes(nil, readTypes: Set(healthkitTypesToRead, completion: { (result: Bool, error: NSError?) -> Void in })
        }
    }*/
        



}