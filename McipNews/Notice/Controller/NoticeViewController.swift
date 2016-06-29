//
//  NoticeViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/29.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        addButton.backgroundColor=UIColor.init(colorLiteralRed: 68/255.0, green: 187/255.0, blue: 234/255.0, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Events
    func btnUser() {
        CommonFunction.exit()
        token = ""
        userid = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true, completion: nil)
    }
    
    @IBAction func boxBtnEvent(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("boxView") as! BoxViewController
        if sender.tag == 200 {
            vc.navigationItem.title = "系统盒子"
            vc.type = 0
        }else{
            vc.navigationItem.title = "陌生人盒子"
            vc.type = 1
        }
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
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

extension NoticeViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("noticeCell")! as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 111
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("noticeDetail")
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
}
