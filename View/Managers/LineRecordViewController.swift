//
//  LineRecordViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/29.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
/// 路线记录
class LineRecordViewController:BaseViewController,UIWebViewDelegate{
    
    var webview:UIWebView?
    var memberId:Int!
    var flag = 0
    var userId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        webview = UIWebView(frame:self.view.bounds)
        webview!.delegate=self
        webview!.scalesPageToFit = true
        webview!.autoresizesSubviews = true; //自动调整大小
        webview!.opaque=false
        webview!.scrollView.zoomScale = 1.0;
        webview!.backgroundColor=UIColor.clearColor()
        self.view.addSubview(webview!)
        loadJspPage()
    }
    /// 加载jsp页面
    func loadJspPage(){
        //远程网页
        
        var url:NSURL?
        if flag == 0{
            url = NSURL(string:URL+"returnMap.zs?memberId=\(memberId)")
        }else{
            url = NSURL(string:URL+"returnMemberlatLong.zs?memberId=\(memberId)&userId=\(userId)")
        }
        let request = NSURLRequest(URL: url!)
         webview!.loadRequest(request)
    }
    
}
