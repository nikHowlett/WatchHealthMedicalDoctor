//
//  Doctor.swift
//  
//
//  Created by MAC-ATL019922 on 6/22/15.
//
//

import Foundation
import CoreData
@objc(Doctor)

class Doctor: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var phoneNumber: String

}
