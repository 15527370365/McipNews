//
//  CallViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class CallViewController: UIViewController {
    
    let defaultColors = [UIColor(red:0.53, green:0.84, blue:0.25, alpha:1),UIColor(red:0.14, green:0.65, blue:0.78, alpha:1),UIColor(red:0.76, green:0.23, blue:0.25, alpha:1)]
    @IBOutlet var arriveNumberLabel: UILabel!
    @IBOutlet var totalNumberLabel: UILabel!
    @IBOutlet var absentNumberLabel: UILabel!
    
    
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
