//
//  Survey.swift
//  
//
//  Created by MAC-ATL019922 on 6/22/15.
//
//

import Foundation
import CoreData
@objc(Survey)

class Survey: NSManagedObject {

    @NSManaged var results: String
    @NSManaged var timeStamp: String

}
