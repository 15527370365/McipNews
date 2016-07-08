//
//  AddNoticeViewController.swift
//  McipNews
//
//  Created by MAC on 16/6/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit

class AddNoticeViewController: UIViewController {

    var selectReceivers = Array<ReceiverCell>()
    @IBOutlet var receiverView: UIView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    
    @IBOutlet var contentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1)
        sendBtn.backgroundColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1)
        // Do any additional setup after loading the view.
        self.contentTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnEvent(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func sendBtnEvent(sender: UIButton) {
        if self.contentTextView.text != "" {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.bezelView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            hud.label.text = "Loading"
            DataTool.sendNotice(self.selectReceivers,content: self.contentTextView.text){ (result) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if result{
                    let alertController = UIAlertController(title: "提示", message: "发送成功", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.contentTextView.resignFirstResponder()
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    self.navigationController?.popToViewController(storyboard.instantiateViewControllerWithIdentifier("noticeView"), animated: true)
                    print(self.navigationController?.viewControllers)
                }else{
                    let alertController = UIAlertController(title: "提示", message: "请稍后再试！", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }else{
            let alertController = UIAlertController(title: "提示", message: "请填写通知内容", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func addReceiverEvent() {
//        let imageView1 = UIImageView(frame:CGRect(x: 0, y: 0, width: 36,height: self.addBtn.frame.height))
//        imageView1.image = UIImage(named: "creatNotice_head1")
//        let imageView2 = UIImageView(frame:CGRect(x: 5+36, y: 0, width: 36,height: self.addBtn.frame.height))
//        imageView2.image = UIImage(named: "creatNotice_head2")
        let containerView = UIScrollView(frame:CGRect(x: 125, y: self.addBtn.frame.origin.y, width: 118,height: self.addBtn.frame.height))
        containerView.contentSize = CGSizeMake(200, 36)
        for i in 0..<selectReceivers.count {
            var sum = 0
            if i != 0 {
                sum = 41*i
            }
            let imageView = UIImageView(frame:CGRect(x: CGFloat(sum), y: 0, width: 36,height: self.addBtn.frame.height))
            if selectReceivers[i].gpic.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 0 {
                imageView.image = UIImage(data: NSData(base64EncodedString: selectReceivers[i].gpic, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
            }else{
                imageView.image = UIImage(named: "creatNotice_head3-1")
            }
            containerView.addSubview(imageView)
        }
        self.receiverView.addSubview(containerView)
        self.sendBtn.setTitleColor(UIColor(red:0.32, green:0.75, blue:0.95, alpha:1), forState: .Normal)
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

extension AddNoticeViewController:UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView){
        self.contentTextView.text = ""
    }
}
