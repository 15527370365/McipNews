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



// TODO: 此结构体存在大量重复代码，需要进行重构
struct DataTool {
    
    static let imageUrlKey = "imageUrlKey"
    
    //项目路径
    static let server = "http://139.129.21.70/mcip"
    
    //let BATH_URL   = "http://www.wanghongyu.cn/mcip"
    
    //POST
    static let post       = server+"/rest/post"
    
    //GET
    static let get        = server+"/rest/get"

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
                let data=JSON(data: result["data"].stringValue.dataUsingEncoding(NSUTF8StringEncoding)!)
                //var array:[Channel]
                
                for i in 0..<data["timetable"].count{
                    if data["timetable"][i]["classinfo"].stringValue != "" {
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
}                                                 

extension NSDate {
    class func TimeIntervalSince1970() -> NSTimeInterval{
        let nowTime = NSDate()
        return nowTime.timeIntervalSince1970
    }
}