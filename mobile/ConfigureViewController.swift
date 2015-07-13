//
//  ConfigureViewController.swift
//  tablesdatasettingshistoryinfo
//
//  Created by MAC-ATL019922 on 6/19/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData
import HealthKit

class ConfigureViewController: UIViewController {

    @IBOutlet weak var doctorname: UITextField!
    
    @IBOutlet weak var docmail: UITextField!
    
    @IBOutlet weak var docphone: UITextField!
    
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.\
        
    }
    
    func handleWatchKitNotification(notification: NSNotification) {
        if let userInfo = notification.object as? [String : String] {
            var shena = userInfo["message"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func savedoc(sender: AnyObject) {
        self.saveDoctor(doctorname.text!, email: docmail.text!, phoneNumber: docphone.text!)
            //sleepEnd: wakeuptimeinfo.text, sleepQuality: sleepqualityinfo.text)
    }
    
    @IBAction func atns(sender: AnyObject) {
        if mySwitch.on {
            /*
            myTextField.text = "The Switch is Off"
            println("Switch is on")
            */
            mySwitch.setOn(false, animated:true)
        } else {
            /*
            myTextField.text = "The Switch is On"
            */
            mySwitch.setOn(true, animated:true)
        }

    }
    
    /*
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var phoneNumber: String
    */
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    
    private func saveDoctor(name: String, email: String, phoneNumber: String) {
        if managedObjectContext != nil {
            let entity = NSEntityDescription.entityForName("Doctor", inManagedObjectContext: managedObjectContext!)
            //@objc(sleep)
            let dok = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!) as! mobile.Doctor
            dok.name = name
            let shjlk = dok.name
            dok.email = email
            dok.phoneNumber = phoneNumber
            //println("\(shjlk)")
            var error: NSError? = nil
            do {
                try managedObjectContext!.save()
                //names.append(name)
                print("\(shjlk)")
            } catch var error1 as NSError {
                error = error1
                print("Could not save \(error), \(error?.userInfo)")
            }
        } else {
            print("Could not get managed object context")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
