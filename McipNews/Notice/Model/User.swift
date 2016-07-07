//
//  User.swift
//  McipNews
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    var userid:String
    var upic:String
    var uname:String
    
    init(json:JSON){
        self.userid = json["userid"].stringValue
        self.upic = json["upic"].stringValue
        self.uname = json["uname"].stringValue
        
    }
}
