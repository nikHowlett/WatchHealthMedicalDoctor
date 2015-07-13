//
//  SleepHistoryObject.swift
//  
//
//  Created by MAC-ATL019922 on 6/22/15.
//
//

import Foundation
import CoreData
@objc(SleepHistoryObject)

class SleepHistoryObject: NSManagedObject {

    @NSManaged var sleepStart: String
    @NSManaged var sleepEnd: String
    @NSManaged var sleepQuality: String

}
