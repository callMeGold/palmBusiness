//
//  SetAnnouncementViewController.swift
//  palmBusiness
//
//  Created by 卢洋 on 16/5/3.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SetAnnouncementViewController:BaseViewController{

    /// 文本视图容器
    var textViews:UITextView!
    /// 保存公告按钮
    var saveBtn:UIButton!
    /// 公司ID
    let companydId = (userDefaults.objectForKey("companyId") as? Int) ?? 0
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "设置公司公告"
        creatUI()
    }
    
    func creatUI(){
        //文本容器
        textViews=UITextView(frame: CGRectMake(10, 84, WIDTH-20, 150));
        textViews.font=UIFont.systemFontOfSize(14)
        textViews.layer.borderWidth=0.5
        textViews.layer.cornerRadius=5
        textViews.layer.borderColor=UIColor.borderColor().CGColor
        textViews.placeholder="暂无公告"
        //textView响应弹出键盘
        textViews.resignFirstResponder()
        textViews.hidden = false
        self.view.addSubview(textViews)
        
        //保存按钮
        saveBtn = UIButton()
        saveBtn.setTitle("保存公告", forState: .Normal)
        saveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveBtn.backgroundColor = UIColor.applicationMainColor()
        saveBtn.layer.cornerRadius = 3
        saveBtn.addTarget(self, action: "saveAnnouncement:", forControlEvents: .TouchUpInside)
        self.view.addSubview(saveBtn)
        self.saveBtn.snp_makeConstraints{(make) -> Void in
            make.top.equalTo(self.textViews.snp_bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.height.equalTo(45)
        }
        //查询公司公告
        getCompanyNotice()
    }
    
    /// 查询公司公告
    func getCompanyNotice(){
        let URLs = URL + "queryCompanyInfo.zs"
        request(.POST, URLs, parameters: ["companyId":companydId], encoding: .URL).responseJSON{res in
            if let _ = res.result.error{
                SVProgressHUD.showInfoWithStatus("服务器异常")
            }
            if let value = res.result.value{
                let jsonResult = JSON(value)
                let announcement = jsonResult["announcement"].stringValue
                self.textViews.text = announcement
            }
        }
    }
    
    /// 保存公司公告
    func saveAnnouncement(sender:UIButton){
        SVProgressHUD.showWithStatus("正在保存...", maskType: .Clear)
        let string = textViews.text ?? "暂无公告哈"
        let URLs = URL + "userUpdateCompanyInfo.zs"
        request(.POST, URLs, parameters: ["companyId":companydId,"announcement":string], encoding: .URL).responseJSON{res in
            if let _ = res.result.error{
                SVProgressHUD.showInfoWithStatus("服务器异常")
            }
            if let value = res.result.value{
                let jsonResult = JSON(value)
                if jsonResult["success"] == "success"{
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showInfoWithStatus("修改失败")
                }
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    
}
