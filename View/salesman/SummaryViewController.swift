//
//  SummaryViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/25.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire

//工作总结
class SummaryViewController:UIViewController {
    
    /// 工作总结
    var text:UITextView?
    
    /// 完成按钮
    var btRegist:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI(){
        self.view.backgroundColor=UIColor.whiteColor()
        
        
        let labTip=UILabel(frame: CGRectMake(0,70,WIDTH,20))
        labTip.text="请在下方填写工作总结"
        labTip.textAlignment=NSTextAlignment.Center
        labTip.font=UIFont.systemFontOfSize(13)
        self.view.addSubview(labTip)
        text=UITextView(frame: CGRectMake(5, 94, WIDTH-10, 200))
        self.view.addSubview(text!)
        text?.layer.borderColor=UIColor.applicationMainColor().CGColor
        text?.layer.borderWidth=1
        text?.layer.cornerRadius=5
        text?.font=UIFont.systemFontOfSize(14)
        text?.scrollEnabled=true
        
        //确认提交按钮
        btRegist=UIButton()
        btRegist?.frame=CGRectMake(15, CGRectGetMaxY(text!.frame)+20, WIDTH-30, 40)
        btRegist?.setTitle("确认提交", forState: .Normal)
        btRegist?.layer.cornerRadius=5
        btRegist?.backgroundColor=UIColor.applicationMainColor()
        btRegist?.addTarget(self, action: "ForgetPassWordBt:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btRegist!)
    
    }
    //提交会员总结
    func ForgetPassWordBt(sender:UIButton){
        if text!.text.characters.count == 0{
            SVProgressHUD.showInfoWithStatus("请填写总结信息")
            text!.resignFirstResponder()
            return
        }else{
            //1.请求地址
            let URLs = URL + "memberSummary.zs"
            //会员ID和总结内容
            let memberID = (userDefaults.objectForKey("memberId") as? Int) ?? 99999
            let content = text!.text ?? ""
            if IJReachability.isConnectedToNetwork(){
                btRegist?.enabled = false
                SVProgressHUD.show()
                request(.POST, URLs, parameters: ["memberId":memberID,"summaryContent":content], encoding: .URL).responseJSON{res in
                    if let _ = res.result.error{
                        SVProgressHUD.showInfoWithStatus("服务器异常")
                        self.btRegist?.enabled = true
                    }
                    if let value = res.result.value{
                        self.btRegist?.enabled = true
                        let jsonResult = JSON(value)
                        if jsonResult["success"] == "success"{
                            SVProgressHUD.showSuccessWithStatus("提交成功")
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }else{
                        self.btRegist?.enabled = true
                        SVProgressHUD.showErrorWithStatus("提交失败")
                    }
                }
            }else{
                SVProgressHUD.showInfoWithStatus("请检查你的网络")
            }
        }
    }
    
}