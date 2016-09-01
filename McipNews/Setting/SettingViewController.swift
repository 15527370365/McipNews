//
//  SettingViewController.swift
//  校园微平台
//
//  Created by MAC on 16/8/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var cacheLabel: UILabel!
    @IBOutlet var versionLabel: UILabel!
    let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cacheLabel.text = self.getCache()
        if self.judgeVersion() {
            self.versionLabel.text = "有可更新版本"
        }else{
            self.versionLabel.text = "已是最新版本"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvents(sender: UIButton) {
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func clearCacheBtnEvents(sender: UIControl) {
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(basePath!){
            let childrenPath = fileManager.subpathsAtPath(basePath!)
            print(childrenPath?.count)
            for childPath in childrenPath!{
                let cachePath = basePath?.stringByAppendingString("/").stringByAppendingString(childPath)
                do{
                    try fileManager.removeItemAtPath(cachePath!)
                }catch {
                    
                }
            }
        }
        let alertController = UIAlertController(title: "提示", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.cacheLabel.text = self.getCache()
        alertController.message = "缓存清除成功！"
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func updateBtnEvents(sender: UIControl) {
        let str = "itms-apps://itunes.apple.com/us/app/xiao-yuan-wei-ping-tai/id1135932048?l=zh&ls=1&mt=8"
        UIApplication.sharedApplication().openURL(NSURL(string: str)!)
    }

    @IBAction func aboutUsBtnEvents(sender: UIControl) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("aboutUs") as! AboutUsViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func exitBtnEvents(sender: UIControl) {
        CommonFunction.exit()
        token = ""
        userid = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController?.pushViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true)
//        self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true, completion: nil)
    }
    
    func getCache() -> String{
        let basePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let fileManager = NSFileManager.defaultManager()
        
        func caculateCache() -> Float{
            var total: Float = 0
            if fileManager.fileExistsAtPath(basePath!){
                let childrenPath = fileManager.subpathsAtPath(basePath!)
                if childrenPath != nil{
                    for path in childrenPath!{
                        let childPath = basePath!.stringByAppendingString("/").stringByAppendingString(path)
                        do{
                            let attr = try fileManager.attributesOfItemAtPath(childPath)
                            let fileSize = attr["NSFileSize"] as! Float
                            total += fileSize
                            
                        }catch _{
                            
                        }
                    }
                }
            }
            
            return total
        }
        let totalCache = caculateCache()
        return NSString(format: "%.2f MB", totalCache / 1024.0 / 1024.0 ) as String
    }
    
    func judgeVersion() -> Bool {
        if self.currentVersion.compare(self.sandboxVersion) == NSComparisonResult.OrderedDescending {
            //存储当前的版本到沙盒
            NSUserDefaults.standardUserDefaults().setObject(self.currentVersion, forKey: "CFBundleShortVersionString")
            //获取到的当前版本 > 之前的版本 = 有新版本
            return true
        }
        //获取到的当前版本 <= 之前的版本 = 没有新版本
        return false
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
