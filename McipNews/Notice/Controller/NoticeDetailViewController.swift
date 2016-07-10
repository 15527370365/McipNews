//
//  NoticeDetailViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    var flag = false
    var notices:Notices!
    var replyDatas = Array<ReplyCell>()

    @IBOutlet var replyTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var userImageButton: UIButton!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(backBtnEvent))
        self.view.addGestureRecognizer(swipeLeftGesture)
        self.setNotices()
        self.getReplyDatas()
        print(self.notices.noticeid)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - init
    func setNotices() {
        self.nameLabel.text = self.notices.uname
        self.timeLabel.text = self.notices.nsendtime
        self.contentLabel.text = self.notices.ncontent
        if notices.upic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            self.userImageButton.setImage(UIImage(data: NSData(base64EncodedString: notices.upic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!), forState: .Normal)
        }else{
            self.userImageButton.setImage(UIImage(named: "default_user_image"), forState: .Normal)
        }
    }
    
    // MARK: - Button Event
    @IBAction func backBtnEvent(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func addSchduleBtnEvent(sender: UIControl) {
        
    }
//    @IBAction func showPersonBtnEvent(sender: UIButton) {
//        
//    }
    
    @IBAction func sendButtonEvent(sender: UIButton) {
        let reply = self.replyTextField.text
        if reply != "" {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            hud.label.text = "Loading"
            DataTool.replyNotice(self.notices.noticeid,nruserid: userid,nreplycontent: reply!){ (result) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if result{
                    let alertController = UIAlertController(title: "提示", message: "回复成功", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.getReplyDatas()
                    self.flag = false
                    self.replyTextField.text = ""
                    self.tableView.scrollsToTop = true
                }else{
                    let alertController = UIAlertController(title: "提示", message: "请稍后再试！", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else{
            let alertController = UIAlertController(title: "提示", message: "请填写回复内容", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    // MARK: - Data
    func getReplyDatas(){
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        hud.label.text = "Loading"
        DataTool.loadNoticesReply(self.notices.noticeid){ (result) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if result.flag{
                self.totalLabel.text = "共\(result.data.count)条回复"
                self.replyDatas = result.data
                self.tableView.reloadData()
            }
        }
    }

//    @IBAction func showConfirmBtnEvent(sender: UIButton) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier("confirmView") as! NoticeConfirmDetailViewController
//        self.hidesBottomBarWhenPushed=true
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.hidesBottomBarWhenPushed=false
//    }
    @IBAction func beginEditReply(sender: AnyObject) {
        flag = true
        let frame = self.tableView.frame
        self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, 200)
    }
    @IBAction func endEditReply(sender: AnyObject) {
        let frame = self.tableView.frame
        self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, 368)
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

extension NoticeDetailViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return replyDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("replyCell")! as UITableViewCell
        let reply = replyDatas[indexPath.row]
        let image = cell.viewWithTag(101) as! UIButton
        if reply.upic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            image.setImage(UIImage(data: NSData(base64EncodedString: notices.upic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!), forState: .Normal)
        }else{
            image.setImage(UIImage(named: "default_user_image"), forState: .Normal)
        }
        let name = cell.viewWithTag(102) as! UILabel
        name.text = reply.uname
        let time = cell.viewWithTag(103) as! UILabel
        time.text = reply.nrtime
        let content = cell.viewWithTag(104) as! UILabel
        content.text = reply.nreplycontent
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if self.flag {
            self.replyTextField.resignFirstResponder()
        }else{
            let reply = replyDatas[indexPath.row]
            replyTextField.text = "回复 \(reply.uname):"
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
}
