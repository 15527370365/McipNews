//
//  NoticeConfirmDetailViewController.swift
//  McipNews
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NoticeConfirmDetailViewController: UIViewController {

    var lastPage = 0
    var currentPage:Int = 0 {
        didSet {
            //根据currentPage 和 lastPage的大小关系，控制页面的切换方向
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
            if currentPage > lastPage {
                self.pageViewController.setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
        }
    }
    
    var pageViewController:UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvent(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func showChild(sender: UIControl) {
        currentPage = sender.tag - 200
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
