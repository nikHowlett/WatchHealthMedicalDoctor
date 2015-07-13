//
//  ViewCon3troller.swift
//  mobile
//
//  Created by MAC-ATL019922 on 7/13/15.
//  Copyright © 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit
import CoreData

class ViewCon3troller: UIViewController {

    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    
    var surveys : [Survey] = [Survey]()
    
    var sleeps : [SleepHistoryObject] = [SleepHistoryObject]()
    
    var tiredz : [Int] = [Int]()
    
    var slpqal : [Int] = [Int]()
    
    var isGraphViewShowing = true
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var typeLengthTime: UILabel!
    @IBOutlet weak var whichohnerawfe: UILabel!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var timePeriodControl: UISegmentedControl!
    @IBOutlet weak var whichData: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaddata()
        loadshit()
        whichohnerawfe.text = "Sleep Quality"
        self.navigationItem.title = "Data Visualizer"
        loadDailySlepp()
        setupGraphDisplay()
    }
    
    func loaddata() {
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "SleepHistoryObject")
        let error: NSError? = nil
        do { sleeps = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [SleepHistoryObject] } catch let error as NSError {
            print("An error occurred loading the data")
        }
        let fetchRequest2 : NSFetchRequest = NSFetchRequest(entityName: "Survey")
        let error2: NSError? = nil
        do { surveys = try managedObjectContext?.executeFetchRequest(fetchRequest2) as! [Survey] }  catch let error2 as NSError {
            print("An error occurred loading the data")
        }
        var heckle = surveys.count
    }

    func loadshit() {
        var lemons: String = "tootsie"
        //if (surveys.count < 7) {
        if (lemons == "tootsie") {
            for (var i = 0; i < surveys.count; i++) {
                let l1 = surveys.count
                let jankjohn = surveys[(l1 - (i+1))].results
                let justthanumba = jankjohn.substringFromIndex(advance(jankjohn.startIndex,11))
                let a:Int? = Int(justthanumba)
                if (a != nil) {
                    tiredz.append(a!)
                } else {
                    for (var i = 0; i < 7; i++) {
                        let l1 = surveys.count
                        let jankjohn = surveys[(l1 - (i+1))].results
                        let justthanumba = jankjohn.substringFromIndex(advance(jankjohn.startIndex,11))
                        let a:Int? = Int(justthanumba)
                        if (a != nil) {
                            tiredz.append(a!)
                        }
                    }
                }
                if (sleeps.count > 7) {
                    for (var i = 0; i < 7; i++) {
                        let l2 = sleeps.count
                        let jankjen = sleeps[(l2-(i+1))].sleepQuality
                        let b:Int? = Int(jankjen)
                        if (b != nil) {
                            slpqal.append(b!)
                        }
                        print("sleepqal count at load > 7 \(slpqal.count)")
                    }
                } else {
                    slpqal = []
                    print(sleeps.count)
                    for (var i = 0; i < (sleeps.count); i++) {
                        let l2 = sleeps.count
                        let jankjen = sleeps[(l2 - (i+1))].sleepQuality
                        let b:Int? = Int(jankjen)
                        if (b != nil) {
                            slpqal.append(b!)
                        }
                        print("sleepqal count at load < 7 \(slpqal.count)")
                    }
                }
            }
        }
        graphView.graphPoints = []
        for (var i = 0; i < slpqal.count; i++) {
            graphView.graphPoints.append(slpqal[i])
        }
        setupGraphDisplayDaily()
    }
    
    func timePeriodChanged(sender: UISegmentedControl) {
        switch timePeriodControl.selectedSegmentIndex
        {
        case 0:
            //textLabel.text = "First Segment Selected";
            //println("case0")
            typeLengthTime.text = "Daily"
            setupGraphDisplayDaily()
            loadDaily()
            if (whichData.selectedSegmentIndex == 1) {
                loadDaily()
            } else {
                loadDailySlepp()
            }
            setupGraphDisplay()
        case 1:
            typeLengthTime.text = "Weekly"
            setupWeeks()
            if (whichData.selectedSegmentIndex == 1) {
                loadWeekly()
            } else {
                loadWeeklySleep()
            }
            setupGraphDisplay()
        case 2:
            //textLabel.text = "First Segment Selected";
            typeLengthTime.text = "Monthly"
            setupGraphDisplayMonthly()
            if (whichData.selectedSegmentIndex == 1) {
                //loadMonthly()
            } else {
                //loadMonthlySleep()
            }
            setupGraphDisplay()
        case 3:
            //textLabel.text = "Second Segment Selected";
            typeLengthTime.text = "Annual"
            setupGraphDisplayAnnualy()
            if (whichData.selectedSegmentIndex == 1) {
                //loadAnnually()
            } else {
                //loadAnnuallySleep()
            }
            setupGraphDisplay()
        default:
            break;
        }
    }
    
    func dataTypeChanged(sender: UISegmentedControl) {
        switch whichData.selectedSegmentIndex
        {
        case 0:
            //graphView.graphPoints = []
            /*for (var i = 0; i < slpqal.count; i++) {
                graphView.graphPoints.append(slpqal[i])
            }*/
            
            whichohnerawfe.text = "Sleep Quality"
            if (timePeriodControl.selectedSegmentIndex == 0) {
                loadDailySlepp()
            } else if (timePeriodControl.selectedSegmentIndex == 1) {
                loadWeeklySleep()
            } else if (timePeriodControl.selectedSegmentIndex == 2) {
                //loadMonthlySleep()
            } else {
                //loadAnnuallySleep()
            }
            setupGraphDisplay()
            //println("sleepcaserun")
            //graphView.graphPoints (they are ints!!!)
            //looks like this var graphPoints:[Int] = [4, 4, 4, 4, 5, 8, 3]
        case 1:
            //graphView.graphPoints = []
            /*for (var i = 0; i <  tiredz.count; i++) {
                graphView.graphPoints.append(tiredz[i])
            }*/
           
            self.whichohnerawfe.text = "General Tiredness"
            if (timePeriodControl.selectedSegmentIndex == 0) {
                loadDaily()
            } else if (timePeriodControl.selectedSegmentIndex == 1) {
                loadWeekly()
            } else if (timePeriodControl.selectedSegmentIndex == 2) {
                //loadMonthly()
            } else {
                //loadAnnually()
            }
            setupGraphDisplay()
            //println("tiredcaserun")
        default:
            break;
        }
    }
    
    func setupGraphDisplay() {
        let noOfDays:Int = 7
        graphView.setNeedsDisplay()
        var totalsum = 0
        //maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        for (var i = 0; i < graphView.graphPoints.count; i++) {
            var thisnum = graphView.graphPoints[i]
            totalsum = totalsum+thisnum
        }
        let average = totalsum/(graphView.graphPoints.count)
        //let average = ((graphView.graphPoints.reduce(0, combine: +))/(graphView.graphPoints.count))
        averageWaterDrunk.text = "\(average)"
    }
    
    func setupWeeks() {
        let noOfDays:Int = 7
        graphView.setNeedsDisplay()
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = components.weekday
        let days = ["S", "S", "M", "T", "W", "T", "F"]
        for i in Array((1...days.count).reverse()) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday--]
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }
    
    func loadDaily() {
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
        let now = NSDate()
        graphView.graphPoints = []
        for (var i = 0; i < tiredz.count; i++) {
            var hiding = surveys[(tiredz.count-i) - 1].timeStamp
            var hiking = hiding.substringToIndex(advance(hiding.startIndex, 9))
            var hifing = "\(now)"
            var hijing = hifing.substringToIndex(advance(hifing.startIndex, 9))
            if (hijing == hiking) {
                graphView.graphPoints.append(tiredz[i])
            }
        }
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }
    
    func loadDailySlepp() {
        let now = NSDate()
        graphView.graphPoints = []
        print("printing slpqal.count: \(slpqal.count)")
        for (var i = 0; i < slpqal.count; i++) {
            let hiding = sleeps[(slpqal.count-i) - 1].sleepStart
            let hiking = hiding.substringToIndex(advance(hiding.startIndex, 9))
            let hifing = "\(now)"
            let hijing = hifing.substringToIndex(advance(hifing.startIndex, 9))
            print(hijing)
            print(hiking)
            if (hijing == hiking) {
                graphView.graphPoints.append(slpqal[i])
            }
        }
        print(graphView.graphPoints[0])
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }
    
    func loadWeeklySleep() {
        let yesterDay = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
        var yesterday = "\(yesterDay!)" as String
        yesterday = yesterday.substringToIndex(advance(yesterday.startIndex,10))
        let yesterDay2 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -2, toDate: NSDate(), options: [])
        var yesterday2 = "\(yesterDay2!)" as String
        yesterday2 = yesterday2.substringToIndex(advance(yesterday2.startIndex,10))
        let yesterday33 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -3, toDate: NSDate(), options: [])
        var yesterday3 = "\(yesterday33!)" as String
        yesterday3 = yesterday3.substringToIndex(advance(yesterday3.startIndex,10))
        let yesterDay4 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -4, toDate: NSDate(), options: [])
        var yesterday4 = "\(yesterDay4!)" as String
        yesterday4 = yesterday4.substringToIndex(advance(yesterday4.startIndex,10))
        let yesterDay5 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -5, toDate: NSDate(), options: [])
        var yesterday5 = "\(yesterDay5!)" as String
        yesterday5 = yesterday5.substringToIndex(advance(yesterday5.startIndex,10))
        let yesterDay6 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -6, toDate: NSDate(), options: [])
        var yesterday6 = "\(yesterDay6!)" as String
        yesterday6 = yesterday6.substringToIndex(advance(yesterday6.startIndex,10))
        let yesterDay7 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: NSDate(), options: [])
        var yesterday7 = "\(yesterDay7!)" as String
        yesterday7 = yesterday7.substringToIndex(advance(yesterday7.startIndex,10))
        let convenientPastSeven = [yesterday, yesterday2, yesterday3, yesterday4, yesterday5, yesterday6, yesterday7]
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = components.weekday
        graphView.graphPoints = []
        var range = [""]
        print(slpqal.count)
        for (var i = 0; i < slpqal.count-1; i++) {
            var thisTimeStampRaw = sleeps[(slpqal.count-i) - 1].sleepEnd
            var hiking = thisTimeStampRaw.substringToIndex(advance(thisTimeStampRaw.startIndex,10))
            var jacobson = false
            for (var jkl = 0; jkl < convenientPastSeven.count; jkl++) {
                if (convenientPastSeven[jkl] == hiking) {
                    print(slpqal)
                    graphView.graphPoints.append(slpqal[(slpqal.count-i)-1])
                    jacobson = true
                }
                if (jkl == convenientPastSeven.count-1) && (jacobson == false) {
                    graphView.graphPoints.append(0)
                }
            }
        }
            /*var currentDate = "\(now)"
            var tStampJustYearMonthDay = hiking.substringToIndex(advance(hiking.startIndex,9))
            var date2Mutiliate = currentDate.substringToIndex(advance(currentDate.startIndex,9))
            var date2Mutiliate2 = currentDate.substringToIndex(advance(currentDate.startIndex,8))
            var currentDayValue = date2Mutiliate.substringFromIndex(advance(date2Mutiliate.startIndex,9))
            var a:Int? = Int(currentDayValue)
            var ax:Int? = Int(currentDayValue)
            if (a != nil) {
                while (a >= 0) {
                    var thisinstring = String(a)
                    a = a! - 1
                    var jeremy: String = date2Mutiliate2 + "\(UnicodeScalar(a!))"
                    range += [jeremy]
                }
            }
            if (ax != nil) {
                while (ax <= 7) {
                    var thisinstring = String(ax)
                    ax = ax! + 1
                    var jeremyx: String = date2Mutiliate2 + "\(UnicodeScalar(a!))"
                    range += [jeremyx]
                }
            }
            var howlongtorunthisnextwhileloop = range.count
            print(howlongtorunthisnextwhileloop)
            print(range)
            for (var uio = 0; uio < range.count; uio++) {
                if (tStampJustYearMonthDay == range[uio]) {
                    graphView.graphPoints.append(slpqal[i])
                }
            }
        }*/
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }

    
    func loadWeekly() {
        let yesterDay = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
        var yesterday = "\(yesterDay!)" as String
        yesterday = yesterday.substringToIndex(advance(yesterday.startIndex,10))
        let yesterDay2 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -2, toDate: NSDate(), options: [])
        var yesterday2 = "\(yesterDay2!)" as String
        yesterday2 = yesterday2.substringToIndex(advance(yesterday2.startIndex,10))
        let yesterday33 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -3, toDate: NSDate(), options: [])
        var yesterday3 = "\(yesterday33!)" as String
        yesterday3 = yesterday3.substringToIndex(advance(yesterday3.startIndex,10))
        let yesterDay4 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -4, toDate: NSDate(), options: [])
        var yesterday4 = "\(yesterDay4!)" as String
        yesterday4 = yesterday4.substringToIndex(advance(yesterday4.startIndex,10))
        let yesterDay5 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -5, toDate: NSDate(), options: [])
        var yesterday5 = "\(yesterDay5!)" as String
        yesterday5 = yesterday5.substringToIndex(advance(yesterday5.startIndex,10))
        let yesterDay6 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -6, toDate: NSDate(), options: [])
        var yesterday6 = "\(yesterDay6!)" as String
        yesterday6 = yesterday6.substringToIndex(advance(yesterday6.startIndex,10))
        let yesterDay7 = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -7, toDate: NSDate(), options: [])
        var yesterday7 = "\(yesterDay7!)" as String
        yesterday7 = yesterday7.substringToIndex(advance(yesterday7.startIndex,10))
        let convenientPastSeven = [yesterday, yesterday2, yesterday3, yesterday4, yesterday5, yesterday6, yesterday7]
        graphView.graphPoints = []
        for (var i = 0; i < tiredz.count-1; i++) {
            var thisTimeStampRaw = surveys[(tiredz.count-i) - 1].timeStamp
            var hiking = thisTimeStampRaw.substringToIndex(advance(thisTimeStampRaw.startIndex,10))
            var jacobson = false
            for (var jkl = 0; jkl < convenientPastSeven.count; jkl++) {
                if (convenientPastSeven[jkl] == hiking) {
                    print(slpqal)
                    graphView.graphPoints.append(tiredz[(tiredz.count-i)-1])
                    jacobson = true
                }
                if (jkl == convenientPastSeven.count-1) && (jacobson == false) {
                    graphView.graphPoints.append(0)
                }
            }
        }
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }

    func loadMonthly() {
        let now = NSDate()
        let schow = "\(now)"
        let monthChecker = schow.substringToIndex(advance(schow.startIndex,7))
        graphView.graphPoints = []
        for (var i = 0; i < tiredz.count-1; i++) {
            var thisTimeStampRaw = surveys[(tiredz.count-i) - 1].timeStamp
            var hiking = thisTimeStampRaw.substringToIndex(advance(thisTimeStampRaw.startIndex,7))
            var jacobson = false
            for (var jkl = 0; jkl < tiredz.count; jkl++) {
                if (monthChecker == hiking) {
                    //print(slpqal)
                    graphView.graphPoints.append(tiredz[(tiredz.count-i)-1])
                    jacobson = true
                }
                /*if (jkl == convenientPastSeven.count-1) && (jacobson == false) {
                    graphView.graphPoints.append(0)
                }*/
            }
        }
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }
    
    func loadMonthlySleep() {
        let now = NSDate()
        let schow = "\(now)"
        let monthChecker = schow.substringToIndex(advance(schow.startIndex,7))
        graphView.graphPoints = []
        for (var i = 0; i < slpqal.count-1; i++) {
            var thisTimeStampRaw = sleeps[(slpqal.count-i) - 1].sleepEnd
            var hiking = thisTimeStampRaw.substringToIndex(advance(thisTimeStampRaw.startIndex,7))
            var jacobson = false
            for (var jkl = 0; jkl < slpqal.count; jkl++) {
                if (monthChecker == hiking) {
                    //print(slpqal)
                    graphView.graphPoints.append(slpqal[(slpqal.count-i)-1])
                    jacobson = true
                }
                /*if (jkl == convenientPastSeven.count-1) && (jacobson == false) {
                graphView.graphPoints.append(0)
                }*/
            }
        }
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
    }
    
    func setupGraphDisplayDaily() {
       let noOfDays:Int = 7
        graphView.setNeedsDisplay()
        //let average = graphView.graphPoints.reduce(0, combine: +)
            // graphView.graphPoints.count
        //averageWaterDrunk.text = "\(average)"
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = 6
        let days = ["12am", "", "", "12pm", "", "", "12am"]
        for i in Array((1...days.count).reverse()) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday--]
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }
    
    func setupGraphDisplayAnnualy() {
        let noOfDays:Int = 12
        graphView.setNeedsDisplay()
        //maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Month
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var month = components.month-1
        let monthNameAbbrvArray = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
        for i in Array((1...monthNameAbbrvArray.count).reverse()) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if month == 12 {
                    month = 0
                }
                labelView.text = monthNameAbbrvArray[month--]
                if month < 0 {
                    month = monthNameAbbrvArray.count - 1
                }
            }
        }
    }

    func setupGraphDisplayMonthly() {
        let noOfDays:Int = 7
        graphView.setNeedsDisplay()
        //maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Month
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        let monthinorder = components.month
        var month = components.month-1
        let monthNameAbbrvArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let monthAbbrev = monthNameAbbrvArray[month]
        var days = ["\(monthAbbrev)", "", "", "15", "", "", "30"]
        if (monthinorder == 1 || monthinorder == 3 || monthinorder == 5 || monthinorder == 7 || monthinorder == 8 || monthinorder == 10 || monthinorder == 12) {
            days = ["\(monthAbbrev)", "", "", "15", "", "", "31"]
        } else if (monthinorder == 2) {
            days = ["\(monthAbbrev)", "", "", "14", "", "", "28"]
        } else {
            days = ["\(monthAbbrev)", "", "", "15", "", "", "30"]
        }
        for i in Array((1...days.count).reverse()) {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if month == 7 {
                    month = 0
                }
                labelView.text = days[month--]
                if month < 0 {
                    month = days.count - 1
                }
            }
        }
    }

    func replace(myString: String, index: Int, newChar: Character) -> String {
        var chars = Array(myString.characters)     // gets an array of characters
        chars[index] = newChar
        var modifiedString = String()
        modifiedString.extend(chars)    // appends array of characters to existing string
        return modifiedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}