//
//  StudentHomeViewController.swift
//  McipNews
//
//  Created by MAC on 16/5/14.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import WMPageController_Swift

class StudentHomeController: PageController {
    
    var vcTitles:[Channel] = []
    var moreTitles:[Channel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
        preloadPolicy = PreloadPolicy.Neighbour
        let result = DataTool.loadNewsChannels(0)
        if !result.1 {
            print("没有关注模块")
            CommonFunction.exit(self)
        }
        //print(result)
        let datas = result.0
        //print(datas)
        for i in 0..<datas["follow"].count{
            vcTitles.append(Channel.init(json: datas["follow"][i]))
        }
        for i in 0..<datas["unfollow"].count{
            moreTitles.append(Channel.init(json: datas["unfollow"][i]))
        }
        self.menuBGColor = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        self.titleColorNormal = UIColor.whiteColor()
        self.titleColorSelected = UIColor.whiteColor()
    }

    override func viewDidLoad() {
        //print("123")
        super.viewDidLoad()
        if vcTitles.count == 0 {
            print("none")
            CommonFunction.exit(self)
        }
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.tintColor = UIColor(red: 34.0/255.0, green: 168.0/255.0, blue: 221.0/255.0, alpha: 1.0)
        //menuView?.rightView = setRightButton()
        self.menuHeight=35
        menuView?.rightView = ButtonTool.setScrollRightAddButton(#selector(StudentHomeController.buttonPressed), view: self, menuHeight: menuHeight)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: ButtonTool.setNavigationLeftImageButton(#selector(StudentHomeController.btnUser), view: self))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private func setRightButton() -> UIView{
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: menuHeight))
//        let line = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 35))
//        line.backgroundColor = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 175.0/255.0, alpha: 1.0)
//        view.addSubview(line)
//        let button = UIButton(frame: CGRect(x: 2, y: 0, width: 48, height: menuHeight))
//        button.addTarget(self, action: #selector(StudentHomeController.buttonPressed), forControlEvents: UIControlEvents.TouchUpInside)
//        button.setImage(UIImage(named: "more"), forState: .Normal)
//        view.addSubview(button)
//        return view
//    }
    
    // MARK: - PageController DataSource
    func numberOfControllersInPageController(pageController: PageController) -> Int {
        return vcTitles.count
    }
    
    func pageController(pageController: PageController, titleAtIndex index: Int) -> String {
        return vcTitles[index].mname
    }
    
    func pageController(pageController: PageController, viewControllerAtIndex index: Int) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("TableViewController") as! NewsTableViewController
        vc.ch = vcTitles[index]
        return vc
    }
    
    func pageController(pageController: PageController, lazyLoadViewController viewController: UIViewController, withInfo info: NSDictionary) {
        //print(info)
    }
    
    override func menuView(menuView: MenuView, widthForItemAtIndex index: Int) -> CGFloat {
        let count = vcTitles[index].mname.characters.count
        //print(count)
        return CGFloat.init(20*count)
    }
    
    // MARK: - Button Events
    
    func buttonPressed() {
        print("+")
        
    }
    
    func btnUser() {
        CommonFunction.exit()
        token = ""
        userid = ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.presentViewController(storyboard.instantiateViewControllerWithIdentifier("Login"), animated: true, completion: nil)
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
