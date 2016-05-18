//
//  AppDelegate.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate{
    var window: UIWindow?
    var mapManager: BMKMapManager?
    var vc:DeckViewController?
    /// 保存用户信息
    var pushNav:UINavigationController?
    var userEntity:UserEntity?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //启动极光推送
        PHJPushHelper.setupWithOptions(launchOptions)
        
        let mainVc=ManagersViewController()
        let leftVc=LeftViewController()
        pushNav=UINavigationController(rootViewController:mainVc)
        vc=DeckViewController(leftView:leftVc, andMainView:pushNav)
        //将返回按钮的文字position设置不在屏幕上显示
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(CGFloat(NSInteger.min),CGFloat(NSInteger.min)), forBarMetrics:UIBarMetrics.Default)
        mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager?.start("jm3NGYfc6zWylcNOvTAS1Wh0rG20Hdqo", generalDelegate:self)  // 注意此时 ret 为 Bool? 类型
        if ret! {  // 如果 ret 为 false，先在后面！强制拆包，再在前面！取反
            NSLog("打开地图成功") // 这里推荐使用 NSLog，
        }
        //初始化键盘库
        let manager = IQKeyboardManager.sharedManager()
        manager.enable = true
        manager.shouldResignOnTouchOutside=true
        
        
        
        //登录过的管理员
        let users=userDefaults.objectForKey("userID") as? Int
        
        //登录过的业务员
        let sales=userDefaults.objectForKey("memberId") as? Int
        if users>0{//管理员
            let app=UIApplication.sharedApplication().delegate as! AppDelegate
            app.vc=vc
            app.window?.rootViewController=app.vc
            
        }else if sales>0{//业务员
            let vc = salesmanViewController()
            let app=UIApplication.sharedApplication().delegate as! AppDelegate
            app.window?.rootViewController=UINavigationController(rootViewController: vc)
        }else{
            let vcLogin = LoginViewController()
            let login=UINavigationController(rootViewController: vcLogin)
            self.window?.rootViewController=login
        }
        //设置菊花图默认前景色和背景色
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //在appdelegate注册设备处调用
        PHJPushHelper.registerDeviceToken(deviceToken)
        
    }
    //当一个运行着的应用程序收到一个远程的通知 发送到委托去...
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //显示本地通知在最前面
        PHJPushHelper.showLocalNotificationAtFront(notification)
    }
    //接收通知消息
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        //转换为json
        let jsonObject=JSON(userInfo)
        //取出nmoreMessage,1-查看业务员位置,2-自动定位
        let flag=jsonObject["nmoreMessage"].intValue
        //取出管理员ID
        let  userId = jsonObject["userId"].intValue
        
        //处理收到的 APNs 消息
        PHJPushHelper.handleRemoteNotification(userInfo, completion:completionHandler)
        NSLog("通知内容-\(userInfo)")
        //if(application.applicationState == UIApplicationState.Active){//如果程序活动在前台
           // NSLog("程序在活动前台,我是业务员")
    NSNotificationCenter.defaultCenter().postNotificationName("getLocationNotification", object: [flag,userId])
       // }else{//如果程序运行在后台
        //    NSLog("程序在活动后台,我是业务员")
        //}
    }
    //程序成为活动状态
    func applicationDidBecomeActive(application: UIApplication) {
        JPUSHService.resetBadge()
        application.applicationIconBadgeNumber=0
        
    }

        
}

