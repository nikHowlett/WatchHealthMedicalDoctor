//
//  SurveyHistoryTableViewController.swift
//  tablesdatasettingshistoryinfo
//
//  Created by MAC-ATL019922 on 6/19/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class SurveyHistoryTableViewController: UITableViewController {
    
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
    
    func handleWatchKitNotification(notification: NSNotification) {
        if let userInfo = notification.object as? [String : String] {
            print("watchnot received/text updatedfromtable")
            data2sendlabel = userInfo["message"]!
        }
        let math: Int = data2sendlabel.characters.count
        if (math > 18) {
        var surveytimestampdata = data2sendlabel.substringToIndex(advance(data2sendlabel.startIndex, 19))
        var surveydatainfo = data2sendlabel.substringFromIndex(advance(data2sendlabel.startIndex,26))
        //self.saveSurvey(surveytimestampdata, results: surveydatainfo)
            //println("savingsurveyfromtable")
        }
    }
    
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
    
    /*
    @IBAction func ohmyshare(sender: AnyObject) {
    let textToShare = "Hey Doctor Scott, my UCB Parkinson's Disease app says I should contact you about my condition."
    let tstamp = data2sendlabel.text!.substringToIndex(advance(data2sendlabel.text!.startIndex, 19))
    //let str = "Hello, darling."
    let surveydata = data2sendlabel.text!.substringFromIndex(advance(data2sendlabel.text!.startIndex,26))
    if let myWebsite = data2sendlabel.text {
    let objectsToShare = [tstamp, textToShare, surveydata]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
    //
    
    self.presentViewController(activityVC, animated: true, completion: nil)
    }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Survey")
        
        let error: NSError? = nil
        do { surveys = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [Survey] } catch let error as NSError { print("An error occurred loading the data") }
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes:[UIUserNotificationType.Sound, UIUserNotificationType.Alert],
                categories: nil))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleWatchKitNotification:"), name: "WatchKitReq", object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return surveys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("surveyCell", forIndexPath: indexPath) as UITableViewCell
        
        let thissurvey : Survey = surveys[indexPath.row] as Survey
        cell.textLabel?.text = thissurvey.timeStamp
        cell.detailTextLabel?.text = thissurvey.results
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            managedObjectContext?.deleteObject(surveys[indexPath.row] as Survey)
            
            var error: NSError? = nil
            do {
                try managedObjectContext!.save()
                surveys.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            } catch var error1 as NSError {
                error = error1
                print("Failed to delete the item \(error), \(error?.userInfo)")
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Peetail":
                let productDetailVC = segue.destinationViewController as! shmetail
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                    productDetailVC.surveyitem = surveyAtIndexPath(indexPath)
                    //println(surveyAtIndexPath(indexPath).results)
                }
                
            default: break
            }
        }
    }
    
    // MARK: - Helper Method
    
    func surveyAtIndexPath(indexPath: NSIndexPath) -> Survey
    {
        let productLine = surveys[indexPath.section]
        return surveys[indexPath.row] as Survey
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
