//
//  DataTool.swift
//  网易新闻
//
//  Created by wl on 15/11/11.
//  Copyright © 2015年 wl. All rights reserved.
//  获得网络数据的工具
/***************************************************
*  如果您发现任何BUG,或者有更好的建议或者意见，请您的指教。
*邮箱:wxl19950606@163.com.感谢您的支持
***************************************************/
import Foundation
import Alamofire
import SwiftyJSON



struct DataTool {
    
    static let imageUrlKey = "imageUrlKey"
    
    //项目路径
    static let server = "http://139.129.21.70/mcip"
    
    //let BATH_URL   = "http://www.wanghongyu.cn/mcip"
    
    //POST
    static let post       = server+"/rest/post"
    
    //GET
    static let get        = server+"/rest/get"
    
    static let common     = server + "/common"

    static func loadNews(moduleid:NSNumber,newsid:NSNumber,type:NSNumber,completionHandler: ([News],state:Bool) -> Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        var parameters = ["":""]
        if type==1 {
            parameters = ["path":"rpc/get_pulldown_news","data":"{\"_moduleid\":"+moduleid.stringValue+",\"_newsid\":"+newsid.stringValue+"}"]
        }else if type == 2{
            parameters = ["path":"rpc/get_pullup_news","data":"{\"_moduleid\":"+moduleid.stringValue+",\"_newsid\":"+newsid.stringValue+"}"]
        }else{
            parameters = ["path":"rpc/get_module_news","data":"{\"_moduleid\":"+moduleid.stringValue+",\"_page\":0}"]
        }
        
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            var news:[News] = []
            if result["code"].string=="200" {
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                //var array:[Channel]
                for i in 0..<data["news"].count{
                    //print(data["news"][i]["ntime"].stringValue)
                    let comps = CommonFunction.formatTime(data["news"][i]["ntime"].stringValue)
                    //let now = CommonFunction.getNowTime()
                    //print("\(comps)----\(now)")
                    let time = "\(comps.month)-\(comps.day) \(comps.hour):\(comps.minute)"
                    //print(data["news"][i])
                    var picture = ""
                    if  data["news"][i]["npicture"] != nil {
                        picture = data["news"][i]["npicture"].stringValue
                    }
                    let new = News(newsid: data["news"][i]["newsid"].intValue, ntitle: data["news"][i]["ntitle"].stringValue, nfrom: data["modulename"].stringValue, ntime: time, nimage: picture)
                    //print("\(new.newsid)+\(new.nimage)+\(new.ntime)+\(new.ntitle)+\(new.nfrom)")
                    news.append(new)
                }
                completionHandler(news,state: true)
            }else{
                completionHandler(news,state: false)
            }
        }
    }
    
    static func loadNewsChannels(type:NSNumber) -> (JSON,Bool){
        //创建NSURL对象
        let url:NSURL! = NSURL(string: POST)
        
        //创建请求对象
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        
        request.HTTPMethod = "POST"//设置请求方式为POST，默认为GET
        let postString = "path=rpc/get_my_modules&data={\"_mtype\":\(type),\"_userid\":\""+userid+"\"}"
        let data:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        
        
        request.addValue(userid, forHTTPHeaderField: "userid")
        request.addValue(token, forHTTPHeaderField: "token")
        request.HTTPBody = data;

        
        //响应对象
        var response:NSURLResponse?
        //发出请求
        do
        {
            let received = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            //let jsonString = NSString(data: received, encoding: NSUTF8StringEncoding)
            let result=JSON(data: received)
            if result["code"].string=="200" {
                let datas=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                return (datas,true)
            }
            return (nil,false)
        }
        catch let error as NSError {
            print("失败：\(error)")//如果失败，error 会返回错误信息
            return (nil,false)
        }
    }
    
    static func loadHomePage(completionHandler:([CellModel],waitingNumber:NSNumber)->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["path":"rpc/main_page","data":"{\"_userid\":\"\(userid)\"}"]
        
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            var cellModel:[CellModel] = []
            if result["code"].string=="200" {
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)[0]
                //var array:[Channel]
                for i in 0..<data["timetable"].count{
                    //print(data["timetable"][i]["classinfo"].count)
                    if data["timetable"][i]["classinfo"].count != 0 {
                        cellModel.append(CellModel(type: 1,data: Course(json:data["timetable"][i],time:i)))
                    }
                }
                
                cellModel.append(CellModel(type: 2,data: NSNull.self))
                for i in 0..<data["news"].count{
                    //print(data["news"][i]["ntime"].stringValue)
                    let comps = CommonFunction.formatTime(data["news"][i]["ntime"].stringValue)
                    //let now = CommonFunction.getNowTime()
                    //print("\(comps)----\(now)")
                    let time = "\(comps.month)-\(comps.day) \(comps.hour):\(comps.minute)"
                    //print(data["news"][i])
                    var picture = ""
                    if  data["news"][i]["npicture"] != nil {
                        picture = data["news"][i]["npicture"].stringValue
                    }
                    let news = News(newsid: data["news"][i]["newsid"].intValue, ntitle: data["news"][i]["ntitle"].stringValue, nfrom: data["modulename"].stringValue, ntime: time, nimage: picture)
                    //print("\(new.newsid)+\(new.nimage)+\(new.ntime)+\(new.ntitle)+\(new.nfrom)")
                    cellModel.append(CellModel(type: 3,data: news))
                }
                completionHandler(cellModel,waitingNumber: data["schedule"].intValue)
            }
        }
    }
    static func loadWeather(completionHandler:(weatherImageName:String,weatherLable:String)->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["path":"武汉"]
        
        let json = fetchJsonFromNet(common, parameters, headers)
        json.jsonToModel(nil) { result in
            if result["errNum"].intValue == 0 {
                let data=result["retData"]
                completionHandler(weatherImageName: "weather11",weatherLable: "\(data["l_tmp"])℃~\(data["h_tmp"])℃")
            }
        }
    }
    
    static func loadNotices(begin:NSNumber,completionHandler:(flag:Bool,data:[Notices],systemcount:NSNumber,strangercount:NSNumber)->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let path = "rpc/get_notices"
        let parameters = ["path":path,"data":"{\"_userid\":\"\(userid)\"}"]
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            var notices:[Notices] = []
            if result["code"].string=="200" {
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                //var array:[Channel]
                for i in 0..<data["mynotice"].count{
                    notices.append(Notices(data: data["mynotice"][i]))
                }
                completionHandler(flag:true,data:notices,systemcount:data["systemcount"].intValue,strangercount:data["strangercount"].intValue)
            }else{
                completionHandler(flag:false,data:notices,systemcount:0,strangercount:0)
            }
        }
    }
    
    static func loadBoxNotices(begin:NSNumber,type:NSNumber,completionHandler:(flag:Bool,data:[Notices])->Void){
        var path = ""
        if type == 0 {
            path = "rpc/get_system_notices"
        }else{
            path = "rpc/get_strangers_notices"
        }
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["path":path,"data":"{\"_userid\":\"\(userid)\",\"_beginindex\":\(begin),\"_num\":20}"]
        //print(parameters)
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            //print(result)
            var notices:[Notices] = []
            if result["code"].string=="200" {
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                //var array:[Channel]
                for i in 0..<data.count{
                    notices.append(Notices(data: data[i]))
                }
                completionHandler(flag:true,data:notices)
            }else{
                completionHandler(flag:false,data:notices)
            }
        }
    }
    static func loadReceiver(completionHandler:(flag:Bool,data:[ReceiverCell])->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["path":"rpc/get_my_groups","data":"{\"_userid\":\""+userid+"\"}"]
        //print(parameters)
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            //print(result)
            var receivers:[ReceiverCell] = []
            if result["code"].string=="200" {
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                //var array:[Channel]
                for i in 0..<data.count{
                    receivers.append(ReceiverCell(json: data[i]))
                }
                completionHandler(flag:true,data:receivers)
            }else{
                completionHandler(flag:false,data:receivers)
            }
        }
    }
    
    
    
    static func loadNoticesReply(noticeid:NSNumber,completionHandler:(flag:Bool,data:[ReplyCell])->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["path":"rpc/get_reply_details","data":"{\"_noticeid\":\(noticeid)}"]
        //print(parameters)
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            //print(result)
            var replys:[ReplyCell] = []
            if result["code"].string=="200" {
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                //var array:[Channel]
                for i in 0..<data.count{
                    replys.append(ReplyCell(json: data[i]))
                }
                completionHandler(flag:true,data:replys)
            }else{
                completionHandler(flag:false,data:replys)
            }
        }
    }
    static func replyNotice(noticeid:NSNumber,nruserid:String,nreplycontent:String,completionHandler:(flag:Bool)->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["path":"rpc/fun_insert_noticereply","data":"{\"_nrnoticeid\":\(noticeid),\"_nruserid\":\""+nruserid+"\",\"_nrruserids\":null,\"_nreplycontent\":\""+nreplycontent+"\"}"]
//        {"_nrnoticeid":425, "_nruserid":"1309030411", "_nrruserids":null, "_nreplycontent":"哈哈哈嘻嘻嘻"}
        print(parameters)
        let json = fetchJsonFromNet(post, parameters, headers)
        json.jsonToModel(nil) { result in
            if result["code"].string=="200" {
                completionHandler(flag:true)
            }else{
                completionHandler(flag:false)
            }
        }
    }
    
    static func sendNotice(select:Array<ReceiverCell>,content:String,completionHandler:(flag:Bool)->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        var nuserid = ""
        for i in 0..<select.count{
            for j in 0..<select[i].members.count{
                if !(i == 0 && j == 0) {
                    nuserid+=";"
                }
                nuserid+=select[i].members[j].userid
            }
        }
        let type = 1
        let remindtype = 0
        let parameters = ["nuserid":nuserid,"ndeadline":"2016-07-20 23:59:00","ncontent":content,"ntype":"\(type)","nremindtype":"\(remindtype)"]
        print(parameters)
        let json = fetchJsonFromNet(server+"/notice/sendNotice", parameters, headers)
        json.jsonToModel(nil) { result in
            if result["code"].string=="40000" {
                completionHandler(flag:true)
            }else{
                completionHandler(flag:false)
            }
        }
    }
    
    static func loadRollCall(info:String,completionHandler:(flag:Bool,content:String)->Void){
        let headers = ["consumer_key": ALAMOFIRE_KEY,"userid":userid,"token":token]
        let parameters = ["info":info]
        //print(parameters)
        let json = fetchJsonFromNet(server+"/rollcall/getScancode", parameters, headers)
        json.jsonToModel(nil) { result in
            var content = ""
            var flag = false
            switch result["code"].stringValue{
                case "10000":
                    content = "在radis中找不到该token"
                case "10001":
                    content = "token与userid不匹配"
                case "10002":
                    content = "cheader中没有token或者没有userid信息"
                case "60000":
                    content = "点名成功"
                case "60001":
                    content = "非点名二维码"
                case "60002":
                    content = "没有参加此次点名的权限"
                case "60003":
                    content = "已通过二维码验证，无需重复验证"
                    flag = true
                case "60004":
                    content = "二维码验证成功"
                    flag = true
                case "60005":
                    content = "更新用户信息时出错"
                case "60006":
                    content = "未完成人脸采集"
                default:
                    content = "二维码无效"
            }
            completionHandler(flag: flag,content: content)
        }
    }
    
}                                                 

extension NSDate {
    class func TimeIntervalSince1970() -> NSTimeInterval{
        let nowTime = NSDate()
        return nowTime.timeIntervalSince1970
    }
}