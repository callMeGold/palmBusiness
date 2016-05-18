//
//  VisitViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/24.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD


class VisitViewController: UIViewController {
    
    /// 姓名输入框
    private var fdName:UITextField!
    
    /// 电话号码输入框
    private var fdPhone:UITextField!
    
    /// 地址输入框
    private var fdAdree:UITextField!
    
    //确认提交按钮
    var btRegist:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //页面布局
        setUI()
    }
    
    func setUI(){
        self.view.backgroundColor=UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1)
        //姓名
        let lbName=setLab("姓名", labY: 64)
        self.view.addSubview(lbName)
        fdName=fdSet(CGRectGetMaxY(lbName.frame), placeholderText: "请输入客户姓名")
        self.view.addSubview(fdName!)
        
        //电话
        let lbPhone=setLab("电话", labY: CGRectGetMaxY(fdName!.frame))
        self.view.addSubview(lbPhone)
        fdPhone=fdSet(CGRectGetMaxY(lbPhone.frame), placeholderText: "请输入客户电话")
        fdPhone.keyboardType = .NumberPad
        self.view.addSubview(fdPhone!)
        
        //地址
        let lbAdree=setLab("地址", labY: CGRectGetMaxY(fdPhone!.frame))
        self.view.addSubview(lbAdree)
        fdAdree=fdSet(CGRectGetMaxY(lbAdree.frame), placeholderText: "请输入客户地址")
        self.view.addSubview(fdAdree!)
        
        //确认提交按钮
        btRegist=UIButton()
        btRegist?.frame=CGRectMake(15, CGRectGetMaxY(fdAdree!.frame)+20, WIDTH-30, 40)
        btRegist?.setTitle("确认拜访", forState: .Normal)
        btRegist?.layer.cornerRadius=5
        btRegist?.backgroundColor=UIColor.applicationMainColor()
        btRegist?.addTarget(self, action: "insertClient:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btRegist!)

        
    }
    
    //创建lab标签
    func setLab(textLab:String,labY:CGFloat) -> UILabel{
        let lab=UILabel()
        lab.text=textLab
        lab.frame=CGRectMake(10, labY, WIDTH, 30)
        lab.font=UIFont.systemFontOfSize(14)
        return lab
    }
    
    //创建输入框
    func fdSet(Y:CGFloat,placeholderText:String) -> UITextField{
        let zoer=UIView(frame: CGRectMake(0,0,10,20))
        let fd:UITextField=UITextField()
        fd.leftView=zoer
        fd.leftViewMode=UITextFieldViewMode.Always
        fd.frame=CGRectMake(0, Y, WIDTH, 30)
        fd.placeholder=placeholderText
        fd.backgroundColor=UIColor.whiteColor()
        fd.font=UIFont.systemFontOfSize(14)
        fd.clearButtonMode=UITextFieldViewMode.WhileEditing
        return fd
    }
    /// 提交客户拜访记录
    func insertClient(sender:UIButton){
        let memberId = (userDefaults.objectForKey("memberId") as? Int) ?? 9999
        var userName = ""
        var userPhone = ""
        var userAddress = ""
        if fdName.text?.characters.count > 0{
            userName = fdName.text!
        }else{
            SVProgressHUD.showInfoWithStatus("请输入姓名")
            fdName.resignFirstResponder()
            return
        }
        if fdPhone.text?.characters.count > 0{
            userPhone = fdPhone.text!
        }else{
            SVProgressHUD.showInfoWithStatus("请输入合法的手机号")
            fdPhone.resignFirstResponder()
            return
        }
        if fdAdree.text?.characters.count > 0{
            userAddress = fdAdree.text!
        }else{
            SVProgressHUD.showInfoWithStatus("请输入地址")
            fdAdree.resignFirstResponder()
            return
        }
        if IJReachability.isConnectedToNetwork(){
            SVProgressHUD.showWithStatus("正在提交...", maskType: .Clear)
            let URLs = URL + "insertClient.zs"
            request(.POST, URLs, parameters: ["clientName":userName,"clientTelPhone":userPhone,"clientAddress":userAddress,"clientSeeMemberId":memberId], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showInfoWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    if jsonResult["success"] == "success"{
                        SVProgressHUD.showSuccessWithStatus("拜访成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else if jsonResult["success"] == "isexist"{
                        SVProgressHUD.showErrorWithStatus("已经拜访过")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        SVProgressHUD.showErrorWithStatus("拜访失败")
                    }
                }
            }
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
}
