//
//  SleepHistoryTableViewController.swift
//  tablesdatasettingshistoryinfo
//
//  Created by MAC-ATL019922 on 6/19/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class SleepHistoryTableViewController: UITableViewController {

    var sleeps : [SleepHistoryObject] = [SleepHistoryObject]()
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "SleepHistoryObject")
        
        let error: NSError? = nil
        do { sleeps = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [SleepHistoryObject] } catch let error as NSError { print("An error occurred loading the data") }
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
        return sleeps.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sleepCell", forIndexPath: indexPath) as UITableViewCell
        
        let name : SleepHistoryObject = sleeps[indexPath.row] as SleepHistoryObject
        cell.textLabel?.text = name.sleepStart
        cell.detailTextLabel?.text = name.sleepQuality
        
        return cell
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            managedObjectContext?.deleteObject(sleeps[indexPath.row] as SleepHistoryObject)
            
            var error: NSError? = nil
            do {
                try managedObjectContext!.save()
                sleeps.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            } catch var error1 as NSError {
                error = error1
                print("Failed to delete the item \(error), \(error?.userInfo)")
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Dragon":
                let productDetailVC = segue.destinationViewController as! detail
                if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                    productDetailVC.sleepitem = sleeperAtIndexPath(indexPath)
                    //productDetailVC.sleepitem = sleeps[indexPath.row] as SleepHistoryObject
                }
                
            default: break
            }
        }
    }
    
    // MARK: - Helper Method
    
    func sleeperAtIndexPath(indexPath: NSIndexPath) -> SleepHistoryObject
    {
        let productLine = sleeps[indexPath.section]
        return sleeps[indexPath.row] as SleepHistoryObject
    }

}
