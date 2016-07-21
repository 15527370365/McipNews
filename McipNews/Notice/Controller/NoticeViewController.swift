//
//  NoticeViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/29.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {
    
    var showDatas = Array<Notices>()
    var allDatas = Array<Notices>()
    var receiveDatas = Array<Notices>()
    var sendDatas = Array<Notices>()
    
    var type = 0
    
    @IBOutlet var strangercountLabel: UILabel!
    @IBOutlet var systemcountLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate=self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,refreshingAction: #selector(NoticeViewController.requestInfo))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(NoticeViewController.requestMoreInfo))
        self.tableView.mj_header.beginRefreshing()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        addButton.backgroundColor=UIColor.init(colorLiteralRed: 68/255.0, green: 187/255.0, blue: 234/255.0, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: ButtonTool.setNavigationLeftImageButton(#selector(NoticeViewController.btnUser), view: self))
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.mj_header.beginRefreshing()
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
    
    @IBAction func codeBtnEvent(sender: UIBarButtonItem) {
        let vc = ScanCodeViewController()
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    // MARK: - Data
    func requestInfo(){
        DataTool.loadNotices(0){ (result) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result.flag{
                self.systemcountLabel.text = "\(result.systemcount)"
                self.strangercountLabel.text = "\(result.strangercount)"
                self.allDatas.removeAll()
                self.receiveDatas.removeAll()
                self.sendDatas.removeAll()
                self.allDatas = result.data
                for notices in result.data{
                    if notices.nflag == 1{
                        self.sendDatas.append(notices)
                    }else{
                        self.receiveDatas.append(notices)
                    }
                }
                self.setShowDatas()
                self.tableView.reloadData()
            }
        }
    }
    
    func requestMoreInfo() {
        DataTool.loadNotices(allDatas.count){ (result) -> Void in
            self.tableView.mj_footer.endRefreshing()
            if result.flag{
                self.systemcountLabel.text = "\(result.systemcount)"
                self.strangercountLabel.text = "\(result.strangercount)"
                self.allDatas += result.data
                for notices in result.data{
                    if notices.nflag == 1{
                        self.sendDatas.append(notices)
                    }else{
                        self.receiveDatas.append(notices)
                    }
                }
                self.setShowDatas()
                self.tableView.reloadData()
            }
        }
    }
    
    func setShowDatas(){
        if self.type == 0 {
            self.showDatas = self.allDatas
        }else if self.type == 1 {
            self.showDatas = self.sendDatas
        }else{
            self.sendDatas = self.receiveDatas
        }
    }

}


// MARK: - Extension
extension NoticeViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - UITableViewDataSourrce
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return showDatas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=self.tableView.dequeueReusableCellWithIdentifier("noticeCell")! as UITableViewCell
        let notices = showDatas[indexPath.row] as Notices
        let name = cell.viewWithTag(101) as! UILabel
        name.text = notices.uname
        let time = cell.viewWithTag(102) as! UILabel
        time.text = notices.nsendtime
        let content = cell.viewWithTag(103) as! UILabel
        content.text = notices.ncontent
        let reply = cell.viewWithTag(104) as! UILabel
        reply.text = "共\(notices.nreplynum)条回复"
        if notices.nstate == 1 {
            let stateImage = cell.viewWithTag(105) as! UIImageView
            stateImage.image = UIImage(named: "notice_allget")
            let stateLabel = cell.viewWithTag(106) as! UILabel
            stateLabel.text = "已全部确认"
        }
        let pic = cell.viewWithTag(100) as! UIImageView
        if notices.upic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
            pic.image = UIImage(data: NSData(base64EncodedString: notices.upic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
        }else{
            pic.image = UIImage(named: "default_user_image")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 111
    }
    
    // MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("noticeDetail") as! NoticeDetailViewController
        vc.notices = showDatas[indexPath.row]
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
