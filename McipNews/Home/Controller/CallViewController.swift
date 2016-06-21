//
//  CallViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtn))
        self.view.addGestureRecognizer(swipeLeftGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(sender: UIBarButtonItem) {
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
