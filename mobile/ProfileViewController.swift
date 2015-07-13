//
//  ProfileViewController.swift
//  tablesdatasettingshistoryinfo
//
//  Created by MAC-ATL019922 on 6/22/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var NAMEKNOWN: UILabel!

    @IBOutlet weak var emailknown: UILabel!

    @IBOutlet weak var phoneknown: UILabel!
    
    var dox : [Doctor] = [Doctor]()
    
    var busPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Doctor")
        let error: NSError? = nil
        do { dox = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [Doctor] } catch let error as NSError { print("An error occurred loading the data") }
        if error != nil {
            print("An error occurred loading the data")
        }
        if (dox.isEmpty) {
            print("nodoctordata")
        } else {
        print(dox[dox.count-1].email)
        NAMEKNOWN.text = dox[dox.count-1].name
        emailknown.text = dox[dox.count-1].email
        phoneknown.text = dox[dox.count-1].phoneNumber
        //phoneknownbutton.description = dox[dox.count-1].phoneNumber
        busPhone = dox[dox.count-1].phoneNumber
        }
    }
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    
    
    @IBAction func callSellerPressed(sender: AnyObject) {
        var newPhone = ""
        for (var i = 0; i < busPhone.characters.count; i++){
            //var current:Int = i
            switch (Array(busPhone.characters)[i]){
                /*let str = "Hello, world!"
                
                let index = advance(str.startIndex, 4)
                str[index] // returns Character 'o' */
            case "0","1","2","3","4","5","6","7","8","9" : newPhone.append(busPhone[advance(busPhone.startIndex, i)])
            default : print("Removed invalid character.")
            }
        }
        
        if  (busPhone.utf16.count > 1){
            
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + newPhone)!)
        }
        else{
            let alert = UIAlertView()
            alert.title = "Sorry!"
            alert.message = "Phone number is not available for this business"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    }
