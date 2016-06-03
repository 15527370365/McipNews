//
//  CommonFunction.swift
//  McipNews
//
//  Created by MAC on 16/4/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreData

class CommonFunction: NSObject {
    class func getMacAddress() -> (success:Bool,ssid:String,mac:String){
        
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let ssid = dict["SSID"]!
                    let mac  = dict["BSSID"]!
                    return (true,ssid as! String,mac as! String)
                }
            }
        }
        return (false,"","")
    }
    
    class func getNowTime() -> NSDateComponents{
        let calender=NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let comps=calender!.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: NSDate())
        return comps;
    }
    
    class func formatTime(time:String)->NSDateComponents{
        let formatter=NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        var timeTemp=(time as NSString).substringToIndex(19)
        //print("time:\(time)+timeTemp:\(timeTemp)")
        timeTemp=timeTemp.stringByReplacingOccurrencesOfString("T", withString: " ")
        //print("time:\(time)+timeTemp:\(timeTemp)")
        let date=formatter.dateFromString(timeTemp)
        let calender=NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        //print(date)
        let comps=calender!.components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: date!)
        return comps;
    }
    
    class func getNowTimeString() -> String{
        let formatter=NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        return formatter.stringFromDate(NSDate())
    }
    
    class func exit(){
        
    }
    
    class func exit(view:AnyObject){
        let appDelegate:AppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        let entity:NSEntityDescription? = NSEntityDescription.entityForName("Users", inManagedObjectContext: managedObjectContext)
        let request:NSFetchRequest = NSFetchRequest()
        request.fetchOffset = 0
        request.fetchLimit = 10
        request.entity = entity
        let predicate = NSPredicate(format: "exitTime== %@","")
        request.predicate = predicate
        do{
            let results:[AnyObject]? = try managedObjectContext.executeFetchRequest(request)
            for user:Users in results as! [Users] {
                user.exitTime = CommonFunction.getNowTimeString()
            }
            try managedObjectContext.save()
        }catch{
            print("Core Data Error!")
        }
        token = ""
        userid = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        view.presentViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true, completion: nil)
    }
    
}
