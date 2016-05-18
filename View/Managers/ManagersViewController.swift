//
//  ManagersViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
//管理员页面
class ManagersViewController:UIViewController,BMKLocationServiceDelegate,UIWebViewDelegate{
    let tempAppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
    var panGesture: UIPanGestureRecognizer!
    //定位信息
    var locService: BMKLocationService!
    var webview:UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="管理员主页"
        self.view.backgroundColor=UIColor.whiteColor()
        //导航栏左边按钮
        let btNavLeft=UIButton(frame: CGRectMake(0,0,20,20))
        btNavLeft.setBackgroundImage(UIImage(named: "cehua"), forState: UIControlState.Normal)
        btNavLeft.addTarget(self, action:"openOrCloseLeftList:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView: btNavLeft)
        
        webview = UIWebView(frame:self.view.bounds)
        webview!.delegate=self
        webview!.scalesPageToFit = true
        webview!.autoresizesSubviews = true; //自动调整大小
        webview!.opaque=false
        webview!.scrollView.zoomScale = 1.0;
        webview!.backgroundColor=UIColor.clearColor()
        self.view.addSubview(webview!)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.desiredAccuracy=kCLLocationAccuracyBest
        locService.distanceFilter=10
        //启动LocationService
        locService.startUserLocationService()
    }
    //定位失败会调用此方法
    func didFailToLocateUserWithError(error:NSError!){
        SVProgressHUD.showErrorWithStatus("定位失败")
    }
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if userLocation.location != nil{//判断地址信息是否获取到  获取到后立即停止定位
            userLocation.location.coordinate;
            //立即停止定位
            locService.stopUserLocationService();
            //远程网页
            let companyId=(userDefaults.objectForKey("companyId") as? Int) ?? 0
            let url = NSURL(string:URL+"userLoginBaiduMap.zs?latLong=\(userLocation.location.coordinate.latitude),\(userLocation.location.coordinate.longitude)&companyId=\(companyId)")
            let request = NSURLRequest(URL: url!)
            webview!.loadRequest(request)
        }
    }
    func openOrCloseLeftList(sender:UIButton){
        
        if (tempAppDelegate.vc!.closed)
        {
            tempAppDelegate.vc!.openLeftView()
        }
        else
        {
            tempAppDelegate.vc!.closeLeftView()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tempAppDelegate.vc!.setPanEnabled(false)
        locService.delegate=nil
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tempAppDelegate.vc!.setPanEnabled(true)
        locService.delegate=self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}