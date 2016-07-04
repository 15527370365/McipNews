//
//  AddNoticeViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class AddNoticeViewController: UIViewController {

    @IBOutlet var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        sendBtn.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvent(sender: AnyObject) {
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
