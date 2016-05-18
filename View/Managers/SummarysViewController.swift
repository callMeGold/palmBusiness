//
//  SummaryViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/5/11.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
/// 总结报表
class SummarysViewController:BaseViewController,UIWebViewDelegate{
    
    var webview:UIWebView?
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
        let companyId=(userDefaults.objectForKey("companyId") as? Int) ?? 0
        var url:NSURL?
        
        url = NSURL(string:URL+"returnMap.zs?memberId=\(companyId)")
       
        let request = NSURLRequest(URL: url!)
        webview!.loadRequest(request)
    }
    
}
