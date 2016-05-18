//
//  DetailsViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/26.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class DetailsViewController: UIViewController {
    
    /// top样式
    private var cellView:UIView?
    
    /// 上个页面传过来的数据
    var entity:MemberEntity!
    
    /// 打卡记录
    private var btCard:UIButton!
    
    /// 路线记录
    private var btLine:UIButton!
    
    /// 工作总结
    private var btWork:UIButton!
    
    /// 当前位置
    private var btAddree:UIButton!
    
    /// 删除此员工
    private var btDelete:UIButton!
    
    /// 客户拜访记录
    private var btRecord:UIButton!
    
    var memberId:Int = 0
    var userId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberId = entity.memberId!
        userId = (userDefaults.objectForKey("userID") as? Int) ?? 0
        //UI布局
        print("memberId....\(memberId)")
        print("UserId....\(userId)")
        showUI()
    }
    override func viewDidDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    //UI布局
    func showUI(){
        self.view.backgroundColor=UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        //top
        let topView=setCell(entity)
        self.view.addSubview(topView)
        
        //打卡记录
        btCard=setBt(1, title: "打卡记录")
        self.view.addSubview(btCard)
        btCard.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(topView.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }
        
        //路线记录
        btLine=setBt(2, title: "路线记录")
        self.view.addSubview(btLine)
        btLine.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btCard.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }
        
        //工作总结
        btWork=setBt(3, title: "工作总结")
        self.view.addSubview(btWork)
        btWork.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btLine.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }
        
        //当前位置
        btAddree=setBt(4, title: "当前位置")
        self.view.addSubview(btAddree)
        btAddree.addTarget(self, action: "getUserLocation:", forControlEvents: .TouchUpInside)
        btAddree.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btWork.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }
        
        //拜访记录
        btRecord=setBt(5, title: "拜访记录")
        self.view.addSubview(btRecord)
        btRecord.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btAddree.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }

        
        //删除员工
        btDelete=setBt(6, title: "删除此员工")
        self.view.addSubview(btDelete)
        btDelete.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btRecord.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }

    }
    
    func setCell(model:MemberEntity) -> UIView{
        cellView=UIView(frame: CGRectMake(0,64,WIDTH,90))
        cellView?.backgroundColor=UIColor.whiteColor()
        //头像
        let image=UIImageView(frame: CGRectMake(10,10,70,70))
        
        let memberPic = model.portrait ?? ""
        image.sd_setImageWithURL(NSURL(string: URLIMG + memberPic), placeholderImage: nil)
        image.layer.cornerRadius=35
        image.layer.masksToBounds=true
        cellView?.addSubview(image)
        
        //姓名
        let name:UILabel=UILabel(frame: CGRectMake(100,15,WIDTH-100,20))
        if let userName = model.realName{
            name.text=userName
        }
        name.font=UIFont.systemFontOfSize(15)
        cellView?.addSubview(name)
        
        //手机号码
        let adree:UILabel=UILabel(frame: CGRectMake(100,60,WIDTH-100,20))
        if let phone = model.memberName{
            adree.text="手机: " + phone
        }else{
            adree.text="手机: "
        }
        adree.font=UIFont.systemFontOfSize(14)
        cellView?.addSubview(adree)
        return cellView!
    }
    //创建按钮
    func setBt(tags:Int,title:String) -> UIButton{
        let btSave=UIButton()
        btSave.setTitle(title, forState: .Normal)
        btSave.layer.cornerRadius=5
        btSave.backgroundColor=UIColor.applicationMainColor()
        btSave.addTarget(self, action: "clickBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btSave.tag=tags
        return btSave
    }
    
    //按钮点击事件
    func clickBt(sender:UIButton){
        
        if sender.tag==1{/// 打卡记录
            
            let vc = CardRecordViewController()
            vc.title="打卡记录"
            vc.tags=0
            vc.memberID=self.entity.memberId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag==2{/// 路线记录
            let lineRecordViewController = LineRecordViewController()
            lineRecordViewController.hidesBottomBarWhenPushed=true
            lineRecordViewController.flag = 0
            lineRecordViewController.title="路线记录"
            lineRecordViewController.memberId=self.memberId
            self.navigationController?.pushViewController(lineRecordViewController, animated: true)
            
        }else if sender.tag==3{/// 工作总结
            let vc = CardRecordViewController()
            vc.title="工作总结"
            vc.tags=1
            vc.memberID=self.entity.memberId
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag==6{/// 删除此员工
            EZAlertController.actionSheet("掌上业务", message: "确定删除此员工?", sourceView: self.view, buttons: ["取消","确定"], tapBlock: { (UIAlertAction, index) -> Void in
                if index==0{//取消
                    print("取消")
                }else{//确定
                    print("确定")
                    
                    //删除会员请求
                    self.userDeleteMember()
                }
            })
            
        }else if sender.tag==5{//拜访记录
            
            let vc=RecordViewController()
            vc.title="客户记录"
            vc.memberId=self.memberId
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
    }
    
    //删除会员请求
    func userDeleteMember(){
        if IJReachability.isConnectedToNetwork(){
            let URLs = URL+"userDeleteMember.xhtml"
            SVProgressHUD.showWithStatus("正在删除...")
            request(.GET, URLs, parameters: ["memberId":memberId]).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    //解析json
                    let resultJson = JSON(value)
                    if resultJson["success"] == "success"{
                        //发送通知
                        NSNotificationCenter.defaultCenter().postNotificationName("nickNameNotification", object: nil)
                        SVProgressHUD.showWithStatus("删除成功!")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        SVProgressHUD.showWithStatus("删除失败!")
                    }
                
                }
            }
            
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
    
    /// 获取业务员位置
    func getUserLocation(sender:UIButton){
        if IJReachability.isConnectedToNetwork(){
            let URLs = URL+"userGainMemberlatLongForPush.zs"
            SVProgressHUD.showWithStatus("正在获取位置...")
            request(.GET, URLs, parameters: ["memberId":memberId,"userId":userId])
            self.performSelector("queryUserGainMemberLatLong", withObject: self, afterDelay: 10)
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
    
    ///查询会员是否根据推送的消息返回了经纬度
    func queryUserGainMemberLatLong(){
        let URLs = URL + "queryUserGainMemberLatLong.zs"
        request(.GET, URLs, parameters: ["memberId":memberId,"userId":userId]).responseJSON{res in
            if let _ = res.result.error{
                SVProgressHUD.showErrorWithStatus("服务器异常")
            }
            if let value = res.result.value{
                let jsonResult = JSON(value)
                if jsonResult["success"] == "success"{
                    SVProgressHUD.showSuccessWithStatus("获取位置成功,正在跳转页面...")
                    self.performSelector("returnMemberlatLong", withObject: self, afterDelay: 1.5)
                }else{
                    SVProgressHUD.showErrorWithStatus("获取位置失败")
                }
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    
    //返回success之后调用jsp页面
    func returnMemberlatLong(){
        let lineRecordViewController = LineRecordViewController()
        lineRecordViewController.hidesBottomBarWhenPushed=true
        lineRecordViewController.flag = 1
        lineRecordViewController.memberId=self.memberId
        lineRecordViewController.userId = self.userId
        lineRecordViewController.title = "当前位置"
        self.navigationController?.pushViewController(lineRecordViewController, animated: true)
    }
}
