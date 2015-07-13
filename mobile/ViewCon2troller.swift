//
//  ViewCon2troller.swift
//  mobile
//
//  Created by A Wizard on a tower
//  Copyright (c) 2010 Gandolf. All rights reserved.
//
/*
import UIKit
import CoreData

class ViewCon2troller: UIViewController {
    /*
    func dateByAddingComponents(comps: NSDateComponents, toDate date: NSDate, options opts: NSCalendarOptions) -> NSDate?
    func dateByAddingUnit(unit: NSCalendarUnit, value: Int, toDate date: NSDate, options: NSCalendarOptions) -> NSDate?
    let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 3, toDate: NSDate(), options: [])*/
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    var surveys : [Survey] = [Survey]()
    
    //var surveys : [Survey] = [Survey]()
    
    var sleeps : [SleepHistoryObject] = [SleepHistoryObject]()
    
    var tiredz : [Int] = [Int]()
    
    var slpqal : [Int] = [Int]()
    
    //Label outlets
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var typeLengthTime: UILabel!
    @IBOutlet weak var whichohnerawfe: UILabel!
    
    var isGraphViewShowing = true
    
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    @IBAction func test(sender: AnyObject) {
        setupGraphDisplay()
    }
    
    //Counter outlets
    //@IBOutlet weak var counterView: CounterView!
    //@IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var sleeps : [SleepHistoryObject] = [SleepHistoryObject]()
        
        var tiredz : [Int] = [Int]()
        
        var slpqal : [Int] = [Int]()
        loaddata()
        loadshit()
        for (var i = 0; i < slpqal.count; i++) {
            graphView.graphPoints[6-i] = slpqal[i]
        }
        whichohnerawfe.text = "Sleep Quality"
        setupGraphDisplayDaily()
        self.navigationItem.title = "Data Visualizer"
        
    }
    
    func loadDaily() {
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
        let now = NSDate()
        graphView.graphPoints = []
        //println("\(yesterday)")
        //println("\(now)")
        for (var i = 0; i < tiredz.count; i++) {
            var hiding = surveys[(tiredz.count-i) - 1].timeStamp
            var hiking = hiding.substringToIndex(advance(hiding.startIndex, 9))
            var hifing = "\(now)"
            var hijing = hifing.substringToIndex(advance(hifing.startIndex, 9))
                if (hijing == hiking) {
                    graphView.graphPoints.append(tiredz[i])
                }
        }
    }
    
    func loadWeekly() {
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = components.weekday
        graphView.graphPoints = []
        var range = [""]
        //println("\(yesterday)")
        //println("\(now)")
        for (var i = 0; i < tiredz.count; i++) {
            var thisTimeStampRaw = surveys[(tiredz.count-i) - 1].timeStamp
            var hiking = thisTimeStampRaw.substringToIndex(advance(thisTimeStampRaw.startIndex,9))
            var currentDate = "\(now)"
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
                    //var jeremy = replace(date2Mutiliate, 9, "\(a)")
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
            for (var uio = 0; uio < range.count; uio++) {
                if (tStampJustYearMonthDay == range[uio]) {
                    graphView.graphPoints.append(tiredz[i])
                }
            }
            /*if (tStampJustYearMonthDay == hiking) {
                graphView.graphPoints.append(tiredz[i])
            }*/
        }
    }
    
    func loadDailySlepp() {
        let now = NSDate()
        graphView.graphPoints = []
        for (var i = 0; i < slpqal.count; i++) {
            let hiding = sleeps[(slpqal.count-i) - 1].sleepStart
            let hiking = hiding.substringToIndex(advance(hiding.startIndex, 9))
            let hifing = "\(now)"
            let hijing = hifing.substringToIndex(advance(hifing.startIndex, 9))
            if (hijing == hiking) {
                graphView.graphPoints.append(slpqal[i])
            }
        }
    }
    
    func loadWeeklySleep() {
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: [])
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = components.weekday
        graphView.graphPoints = []
        var range = [""]
        //println("\(yesterday)")
        //println("\(now)")
        for (var i = 0; i < slpqal.count; i++) {
            var thisTimeStampRaw = sleeps[(slpqal.count-i) - 1].sleepEnd
            var hiking = thisTimeStampRaw.substringToIndex(advance(thisTimeStampRaw.startIndex,9))
            var currentDate = "\(now)"
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
                    //var jeremy = replace(date2Mutiliate, 9, "\(a)")
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
            for (var uio = 0; uio < range.count; uio++) {
                if (tStampJustYearMonthDay == range[uio]) {
                    graphView.graphPoints.append(slpqal[i])
                }
            }
        }
    }

    
    /*func percentOfDay(stringedDate) {
        
    }*/
    
    func loaddata() {
        /*SWIFT 2.0
        do {
        list = try context.executeFetchRequest(request)
        // success ...
        } catch let error as NSError {
        // failure
        print("Fetch failed: \(error.localizedDescription)")
        }
        */
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "SleepHistoryObject")
        
        let error: NSError? = nil
        do { sleeps = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [SleepHistoryObject] } catch let error as NSError {
            print("An error occurred loading the data")
        }
        let fetchRequest2 : NSFetchRequest = NSFetchRequest(entityName: "Survey")
        
        let error2: NSError? = nil
        do { surveys = try managedObjectContext?.executeFetchRequest(fetchRequest2) as! [Survey] }  catch let error2 as NSError {
            print("An error occurred loading the data")
            }
        }
        var heckle = surveys.count
    }
    
    func loadshit() {
        var lemons: String = "tootsie"
        if (surveys < 7) {
            for (var i = 0; i < surveys.count; i++) {
                let l1 = surveys.count
                let jankjohn = surveys[(l1 - (i+1))].results
                let justthanumba = jankjohn.substringFromIndex(advance(jankjohn.startIndex,11))
                //println("\(justthanumba)")
                let a:Int? = Int(justthanumba)
                if (a != nil) {
                    tiredz.append(a!)
                }
                //println("Tired count \(tiredz.count)")
            }
        } else {
            for (var i = 0; i < 7; i++) {
                let l1 = surveys.count
                let jankjohn = surveys[(l1 - (i+1))].results
                let justthanumba = jankjohn.substringFromIndex(advance(jankjohn.startIndex,11))
                //println("\(justthanumba)")
                let a:Int? = Int(justthanumba)
                if (a != nil) {
                    tiredz.append(a!)
                }
                //println("Tired count \(tiredz.count)")
            }
        }
        if (sleeps.count < 7) {
            for (var i = 0; i < (sleeps.count); i++) {
                let l2 = sleeps.count
                let jankjen = sleeps[(l2 - (i+1))].sleepQuality
                let b:Int? = Int(jankjen)
                if (b != nil) {
                    slpqal.append(b!)
                }
            }
        } else {
            for (var i = 0; i < 7; i++) {
                let l2 = sleeps.count
                let jankjen = sleeps[(l2-(i+1))].sleepQuality
                let b:Int? = Int(jankjen)
                if (b != nil) {
                    slpqal.append(b!)
                }
            }
        }
        //graphView.graphPoints (they are ints!!!)
        //looks like this var graphPoints:[Int] = [4, 4, 4, 4, 5, 8, 3]
        /* String to Int!
        // toInt returns optional that's why we used a:Int?
        let a:Int? = firstText.text.toInt() // firstText is UITextField
        let b:Int? = secondText.text.toInt() // secondText is UITextField
        
        // check a and b before unwrapping using !
        if a && b {
        var ans = a! + b!
        answerLabel.text = "Answer is \(ans)"       // answerLabel ie UILa
        } else {
        answerLabel.text = "Input values are not numberic"
        }
        */
    }
    
    /*@IBAction func btnPushButton(button: PushButtonView) {
        if button.isAddButton {
            counterView.counter++
        } else {
            if counterView.counter > 0 {
                counterView.counter--
            }
        }
        counterLabel.text = String(counterView.counter)
        if isGraphViewShowing {
            counterViewTap(nil)
        }
    }*/
    
    /*@IBAction func counterViewTap(gesture:UITapGestureRecognizer?) {
        if (isGraphViewShowing) {
            
            //hide Graph
            UIView.transitionFromView(graphView,
                toView: counterView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromLeft
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion:nil)
        } else {
            
            //show Graph
            
            setupGraphDisplay()
            
            UIView.transitionFromView(counterView,
                toView: graphView,
                duration: 1.0,
                options: UIViewAnimationOptions.TransitionFlipFromRight
                    | UIViewAnimationOptions.ShowHideTransitionViews,
                completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }*/
    weak var s1: UILabel!
    
    weak var s2: UILabel!
    
    weak var s3: UILabel!
    
    weak var s4: UILabel!
    
    weak var s5: UILabel!
    
    weak var s6: UILabel!
    
    weak var s7: UILabel!
    
    weak var timePeriodControl: UISegmentedControl!
    
    weak var whichData: UISegmentedControl!
    
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
        case 1:
            //textLabel.text = "Second Segment Selected";
            typeLengthTime.text = "Weekly"
            setupGraphDisplay()
            setupWeeks()
            if (whichData.selectedSegmentIndex == 1) {
                loadWeekly()
            } else {
                loadWeeklySleep()
            }
        case 2:
            //textLabel.text = "First Segment Selected";
            typeLengthTime.text = "Monthly"
            setupGraphDisplayMonthly()
        case 3:
            //textLabel.text = "Second Segment Selected";
            typeLengthTime.text = "Annual"
            setupGraphDisplayAnnualy()
        default:
            break;
        }
    }
    
    func dataTypeChanged(sender: UISegmentedControl) {
        switch whichData.selectedSegmentIndex
        {
        case 0:
            //textLabel.text = "First Segment Selected";
            //println("case0")
            for (var i = 0; i < slpqal.count; i++) {
                graphView.graphPoints[6-i] = slpqal[i]
            }
            setupGraphDisplay()
            whichohnerawfe.text = "Sleep Quality"
            //println("sleepcaserun")
            //graphView.graphPoints (they are ints!!!)
            //looks like this var graphPoints:[Int] = [4, 4, 4, 4, 5, 8, 3]
        case 1:
            //textLabel.text = "Second Segment Selected";
            for (var i = 0; i <  tiredz.count; i++) {
                graphView.graphPoints[6-i] = tiredz[i]
            }
            setupGraphDisplay()
            self.whichohnerawfe.text = "General Tiredness"
            //println("tiredcaserun")
        default:
            break;
        }
    }
    
    func setupGraphDisplay() {
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //1 - replace last day with today's actual data
        //graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        
        //3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
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
        
        /*for (var i = 1; i < 8; i++) {
        
        }*/
        
        //5 - set up the day name labels with correct day
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
    
    func setupGraphDisplayDaily() {
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 7
        
        //1 - replace last day with today's actual data
        //graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        
        //3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var weekday = 6
        //print(weekday)
        
        let days = ["12am", "", "", "12pm", "", "", "12am"]
        
        /*for (var i = 1; i < 8; i++) {
        
        }*/
        
        //5 - set up the day name labels with correct day
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
        
        //Use 7 days for graph - can use any number,
        //but labels and sample data are set up for 7 days
        let noOfDays:Int = 12
        
        //1 - replace last day with today's actual data
        //graphView.graphPoints[graphView.graphPoints.count-1] = counterView.counter
        
        //2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
        
        //3 - calculate average from graphPoints
        let average = graphView.graphPoints.reduce(0, combine: +)
            / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        //set up labels
        //day of week labels are set up in storyboard with tags
        //today is last day of the array need to go backwards
        
        //4 - get today's day number
        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions:NSCalendarUnit = .Month
        let components = calendar.components(componentOptions,
            fromDate: NSDate())
        var month = components.month-1
        //print(weekday)
        
        let monthNameAbbrvArray = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
        
        /*for (var i = 1; i < 8; i++) {
        
        }*/
        
        //5 - set up the day name labels with correct day
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
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"
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

*/
