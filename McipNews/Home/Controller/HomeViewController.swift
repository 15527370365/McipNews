//
//  HomeViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class HomeViewController:UIViewController {

    @IBOutlet var titleItem: UINavigationItem!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    
    var week:String = "第5周"
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight = self.navigationController!.navigationBar.frame.size.height
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView=UIView(frame: CGRectZero)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(HomeViewController.btnUser), view: self))
        self.navigationItem.titleView = ButtonTool.setNavigationMiddleItem(#selector(HomeViewController.btnUser), view: self, barHeight: barHeight, week: self.week)
        //setNavigationItems()
        weekLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2));
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.size.width * 0.5
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.whiteColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setNavigationItems(){
//        let barHeight = self.navigationController!.navigationBar.frame.size.height
//        let middleItem = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: barHeight))
//        let weekTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 45, height: barHeight))
//        weekTitle.text = week
//        weekTitle.font = UIFont(name: "System", size: 32.0)
//        middleItem.addSubview(weekTitle)
//        let weekBtn = UIButton.init(type:UIButtonType.Custom)
//        weekBtn.frame = CGRect(x: 45, y: 0, width: 30, height: barHeight)
//        weekBtn.setImage(UIImage(named: "home_week_down"), forState: UIControlState.Normal)
//        weekBtn.layer.masksToBounds = true
//        weekBtn.layer.cornerRadius = weekBtn.bounds.size.width * 0.5
//        weekBtn.addTarget(self, action: #selector(NewsViewController.btnUser), forControlEvents: UIControlEvents.TouchUpInside)
//        middleItem.addSubview(weekBtn)
//        
//        self.navigationItem.titleView = middleItem
//    }
    
    // MARK: - Button Events
    func btnUser() {
        CommonFunction.exit()
        token = ""
        userid = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true, completion: nil)
    }
    
    @IBAction func itemsClick(sender: UIControl) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("WaitingItems") as! ItemsViewController
        self.navigationController?.pushViewController(vc, animated: true)
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

// MARK: - tableView extension
extension HomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
            let cell=self.tableView.dequeueReusableCellWithIdentifier("courseCell")! as UITableViewCell
            return cell
        }else if indexPath.row == 1{
            let cell=self.tableView.dequeueReusableCellWithIdentifier("noneCell")! as UITableViewCell
            cell.selectionStyle = .None
            return cell
        }else{
            let cell=self.tableView.dequeueReusableCellWithIdentifier("newsCell")! as UITableViewCell
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return 70
        }else if indexPath.row == 1{
            return 127
        }else{
            return 80
        }
    }
}



