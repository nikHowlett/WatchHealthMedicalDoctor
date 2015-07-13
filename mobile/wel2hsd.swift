//
//  wel2hsd.swift
//  mobile
//
//  Created by MAC-ATL019922 on 7/7/15.
//  Copyright (c) 2015 UCB+nikhowlett. All rights reserved.
//

import UIKit

class wel2hsd: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*var navigationBarAppearace = UINavigationBar.appearance()
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x062134)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        navigationBarAppearace.tintColor = uicolorFromHex(0x062134)
        navigationBarAppearace.barTintColor = uicolorFromHex(0x062134)
        println("well this is weird")
        //navigationBarAppearace.tintColor = ui
        // change navigation item title colour
        //UINavigationBar.appearance().barTintColor = UIColo
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}


extension UIColor {
    convenience init(hex: Int) {
        let r = hex / 0x10000
        let g = (hex - r*0x10000) / 0x100
        let b = hex - r*0x10000 - g*0x100
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}

/*
var navigationBarAppearace = UINavigationBar.appearance()

navigationBarAppearace.tintColor = uicolorFromHex(0xffffff)
navigationBarAppearace.barTintColor = uicolorFromHex(0x034517)

// change navigation item title color
navigationBarAppearace.titleTextAttributes =[NSForegroundColorAttributeName:UIColor.whiteColor()]
*/