//
//  NewsDetailViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet var detailTitle: UINavigationItem!
    @IBOutlet var webView: UIWebView!
    var newsid:NSNumber!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = NSURL(string:NEWS_DETAIL+"\(newsid)")
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10)
        
        request.HTTPMethod = "GET"//设置请求方式为POST，默认为GET
        request.addValue(userid, forHTTPHeaderField: "userid")
        request.addValue(token, forHTTPHeaderField: "token")
        webView.loadRequest(request)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backClick))
        self.view.addGestureRecognizer(swipeLeftGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func backClicks(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
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
