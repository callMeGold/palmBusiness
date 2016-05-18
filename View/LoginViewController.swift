//
//  LoginViewController.swift
//  palmBusiness
//ManagersViewController
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import ObjectMapper
//登陆页面

class LoginViewController: UIViewController {
    //上部图片容器
    private var topImg:UIImageView?
    
    /// 用户名输入框
    private var fdUser:UITextField?
    
    /// 密码输入框
    private var fdPassWord:UITextField?
    
    /// 找回密码
    private var btForgotPassword:UIButton?
    
    /// 用户注册
    private var btRegist:UIButton?
    
    /// 管理者登录
    private var btManagers:UIButton?
    
    /// 业务员登录
    private var btSalesman:UIButton?
    
    //判断（0：管理员，1：业务员）
    var tags:Int!
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景
        setBackImg()
        
        //UI布局
        setUI()
    }
    func setBackImg(){
        self.view.backgroundColor=UIColor.whiteColor()
        
        //图片
        topImg=UIImageView()
        topImg?.frame=CGRectMake(0,20,WIDTH,HEIGHT-20)
        topImg?.image=UIImage(named: "login_back")
        self.view.addSubview(topImg!)
        
    }
    func setUI(){
        var fdUserHeight:CGFloat?
        if HEIGHT==667{
            fdUserHeight=330
        }else if HEIGHT==480{
           fdUserHeight=240
        }else if HEIGHT==568{
            fdUserHeight=280
        }else if HEIGHT>680{
            fdUserHeight=360
        }
        /// 用户名输入框
        let viewOne=UIView(frame: CGRectMake(0,0,30,20))
        let imgOne:UIImageView=UIImageView(frame: CGRectMake(0,0,20,20))
        imgOne.image=UIImage(named: "acount")
        viewOne.addSubview(imgOne)
        fdUser=UITextField(frame: CGRectMake(15,fdUserHeight!,WIDTH-30,30))
        fdUser?.leftView=viewOne
        fdUser?.placeholder="请输入用户名"
        fdUser?.font=UIFont.systemFontOfSize(14)
        fdUser?.leftViewMode=UITextFieldViewMode.Always
        fdUser?.clearButtonMode=UITextFieldViewMode.WhileEditing
        self.view.addSubview(fdUser!)
        
        //横线1
        let lineOne=UIView(frame: CGRectMake(15,CGRectGetMaxY(self.fdUser!.frame)+10,WIDTH-30,0.5))
            lineOne.backgroundColor=UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)
            self.view.addSubview(lineOne)
        
        /// 密码输入框
        let viewTwo=UIView(frame: CGRectMake(0,0,30,20))
        let imgTwo:UIImageView=UIImageView(frame:CGRectMake(0, 0, 20, 20))
        imgTwo.image=UIImage(named: "psw")
        viewTwo.addSubview(imgTwo)
        fdPassWord=UITextField(frame: CGRectMake(15,CGRectGetMaxY(lineOne.frame)+10,WIDTH-30,30))
        fdPassWord?.leftView=viewTwo
        fdPassWord?.placeholder="请输入密码"
        fdPassWord?.secureTextEntry = true
        fdPassWord?.font=UIFont.systemFontOfSize(14)
        fdPassWord?.leftViewMode=UITextFieldViewMode.Always
        fdPassWord?.clearButtonMode=UITextFieldViewMode.WhileEditing
        self.view.addSubview(fdPassWord!)

        //横线2
        let linetwo=UIView(frame: CGRectMake(15,CGRectGetMaxY(self.fdPassWord!.frame)+10,WIDTH-30,0.5))
        linetwo.backgroundColor=UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1)
        self.view.addSubview(linetwo)
        
        /// 找回密码
        btForgotPassword=UIButton()
        btForgotPassword?.setTitle("找回密码", forState: UIControlState.Normal)
        btForgotPassword?.addTarget(self, action: "clickBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btForgotPassword?.tag=1
        btForgotPassword?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btForgotPassword?.titleLabel?.font=UIFont.systemFontOfSize(14)
        self.view.addSubview(btForgotPassword!)
        btForgotPassword?.snp_makeConstraints{(make) -> Void in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(linetwo.snp_bottom).offset(15)
        }
        
        /// 用户注册
        btRegist=UIButton()
        btRegist?.setTitle("用户注册", forState: .Normal)
        btRegist?.frame=CGRectMake(WIDTH-100,CGRectGetMinY(btForgotPassword!.frame),100,40)
        btRegist?.addTarget(self, action: "clickBt:", forControlEvents: .TouchUpInside)
        btRegist?.tag=2
        btRegist?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btRegist?.titleLabel?.font=UIFont.systemFontOfSize(14)
        self.view.addSubview(btRegist!)
        btRegist?.snp_makeConstraints{(make) -> Void in
            make.right.equalTo(self.view.snp_right).offset(-15)
            make.top.equalTo(linetwo.snp_bottom).offset(15)
        }
        /// 管理者登录
        btManagers=UIButton()
        btManagers?.frame=CGRectMake(15, CGRectGetMaxY(btForgotPassword!.frame)+10, WIDTH/2-25, 50)
        btManagers?.layer.cornerRadius=5
        btManagers?.addTarget(self, action: "clickBt:", forControlEvents: .TouchUpInside)
        btManagers?.tag=3
        btManagers?.backgroundColor=UIColor.applicationMainColor()
        btManagers?.setTitle("管理者登录", forState: .Normal)
        btManagers?.titleLabel?.font=UIFont.systemFontOfSize(15)
        self.view.addSubview(btManagers!)
        btManagers?.snp_makeConstraints{(make) -> Void in
            make.top.equalTo(btForgotPassword!.snp_bottom).offset(15)
            make.left.equalTo(self.view).offset(15)
            make.width.equalTo(WIDTH/2-25)
            if WIDTH==375{
                make.height.equalTo(50)
            }else{
                make.height.equalTo(40)
            }
            
        }
        
        /// 业务员登录
        btSalesman=UIButton()
        btSalesman?.frame=CGRectMake(WIDTH/2+10, CGRectGetMinY(btManagers!.frame), WIDTH/2-25, 50)
        btSalesman?.layer.cornerRadius=5
        btSalesman?.addTarget(self, action: "clickBt:", forControlEvents: .TouchUpInside)
        btSalesman?.tag=4
        btSalesman?.backgroundColor=UIColor.applicationMainColor()
        btSalesman?.setTitle("业务员登录", forState: .Normal)
        btSalesman?.titleLabel?.font=UIFont.systemFontOfSize(15)
        self.view.addSubview(btSalesman!)
        btSalesman?.snp_makeConstraints{(make) -> Void in
            make.top.equalTo(btForgotPassword!.snp_bottom).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.width.equalTo(WIDTH/2-25)
            if WIDTH==375{
                make.height.equalTo(50)
            }else{
                make.height.equalTo(40)
            }

        }
        
        //公司标签
        let labNvmroe:UILabel=UILabel()
        labNvmroe.text="湖南奈文摩尔网络科技有限公司"
        labNvmroe.font=UIFont.systemFontOfSize(14)
        self.view.addSubview(labNvmroe)
        labNvmroe.snp_makeConstraints{(make) -> Void in
            make.bottom.equalTo(self.view).offset(-15)
            make.centerX.equalTo(self.view.snp_centerX)
        }
        
    }
    func clickBt(sender:UIButton){
        
        if sender.tag==1{/// 找回密码
            let action=UIAlertController(title: "掌上业务", message: "找回密码", preferredStyle: .ActionSheet)
            let Manga=UIAlertAction(title: "管理员", style: .Default, handler: { (mange) -> Void in
                self.tags=0
                let vc = RegistViewController()
                vc.title="找回密码"
                vc.tags=self.tags
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let sla=UIAlertAction(title: "业务员", style: .Default, handler: { (sla) -> Void in
                self.tags=1
                let vc = RegistViewController()
                vc.title="找回密码"
                vc.tags=self.tags
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let cancel=UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            action.addAction(Manga)
            action.addAction(sla)
            action.addAction(cancel)
            self.presentViewController(action, animated: true, completion: nil)
            
            
        }else if sender.tag==2{/// 用户注册
            
            let vc = RegistViewController()
            vc.title="注册"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let name=fdUser!.text
            let password=fdPassWord!.text
            if name == ""{
                SVProgressHUD.showInfoWithStatus("用户名不能为空")
                return
            }else if password == ""{
                SVProgressHUD.showInfoWithStatus("密码不能为空")
                return
            }else{
                SVProgressHUD.showWithStatus("正在登陆",maskType: SVProgressHUDMaskType.Gradient)
                var url=""
                var parameters:[String: AnyObject]?
                if sender.tag == 3{// 管理者登录
                    url=URL+"queryUserInfo.zs"
                    parameters=["userAccount":name!,"userPossword":password!]
                }else if sender.tag == 4{// 业务员登录
                    url=URL+"queryMemberInfo.zs"
                    parameters=["memberName":name!,"password":password!]
                }
                request(.POST,url, parameters:parameters).responseJSON{ response in
                    if response.result.error != nil{
                        SVProgressHUD.showErrorWithStatus("服务器异常")
                    }
                    if response.result.value != nil{
                        let json=JSON(response.result.value!)
                        let success=json["success"].stringValue
                        SVProgressHUD.dismiss()
                        if success == "success"{
                            
                            
                            if sender.tag==3{//跳管理员页面
                                let entity=Mapper<UserEntity>().map(json["mEntity"].object)
                                //保存会员Id
                                userDefaults.setObject(entity?.userID, forKey:"userID")
                                //保存会员名
                                userDefaults.setObject(entity?.userName, forKey:"userName")
                                //保存会员帐号
                                userDefaults.setObject(entity?.userAccount, forKey:"userAccount")
                                //保存会员密码
                                userDefaults.setObject(entity?.userPossword, forKey:"userPossword")
                                //保存会员注册时间
                                userDefaults.setObject(entity?.ctime, forKey:"ctime")
                                //保存所属公司ID
                                userDefaults.setObject(entity?.companyId, forKey:"companyId")
                                //保存是否删除（1 未删除 2 删除）
                                userDefaults.setObject(entity?.flag, forKey:"flag")
                                //保存 公司名称
                                userDefaults.setObject(entity?.companyName, forKey: "companyName")
                                NSLog("当前用户-\(json["mEntity"])")
                                
                                let app=UIApplication.sharedApplication().delegate as! AppDelegate
                                let mainVc=ManagersViewController()
                                let leftVc=LeftViewController()
                                app.pushNav=UINavigationController(rootViewController:mainVc)
                                app.vc=DeckViewController(leftView:leftVc, andMainView:app.pushNav)
                                app.window?.rootViewController=app.vc
                            }else if sender.tag==4{//跳业务员页面
                                let entity=Mapper<MemberEntity>().map(json["mEntity"].object)
                                NSLog("当前用户-\(json["mEntity"])")
                                /****** 用户Id ***/
                                userDefaults.setObject(entity?.memberId, forKey:"memberId")
                                /****** 用户名 ***/
                                userDefaults.setObject(entity?.memberName, forKey:"memberName")
                                /****** 密码 ***/
                                userDefaults.setObject(entity?.password, forKey:"password")
                                /****** 真实姓名 ***/
                                userDefaults.setObject(entity?.realName, forKey:"realName")
                                /****** 性别(1,男2,女) ***/
                                userDefaults.setObject(entity?.gender, forKey:"gender")
                                /****** 手机 ***/
                                userDefaults.setObject(entity?.phone_mob, forKey:"phone_mob")
                                /****** 注册时间 ***/
                                userDefaults.setObject(entity?.regtime, forKey:"regtime")
                                /****** 最后登录时间 ***/
                                userDefaults.setObject(entity?.lastLogin, forKey:"lastLogin")
                                /****** 照片 ***/
                                userDefaults.setObject(entity?.portrait, forKey:"portrait")
                                /****** 是否激活(1，激活，2未激活) ***/
                                userDefaults.setObject(entity?.activation, forKey:"activation")
                                /****** 会员二维码 ***/
                                userDefaults.setObject(entity?.qrcode, forKey:"qrcode")
                                /****** 会员所属公司Id ***/
                                userDefaults.setObject(entity?.companyId, forKey:"companyId")
                                
                                /****** 会员所属公司名称    与数据库无关 ***/
                               
                                userDefaults.setObject(entity?.companyName, forKey:"companyName")
                                
                                //开始自动定位的时间
                                userDefaults.setObject(entity?.timeingLatlongStart, forKey:"timeingLatlongStart")
                                //结束自动定位的时间
                                userDefaults.setObject(entity?.timeingLatlongEnd, forKey:"timeingLatlongEnd")
                                //上午打卡开始时间
                                userDefaults.setObject(entity?.amCardStart, forKey:"amCardStart")
                                //上午打卡结束时间
                                userDefaults.setObject(entity?.amCardEnd, forKey:"amCardEnd")
                                userDefaults.setObject(entity?.pmCardStart, forKey:"pmCardStart")//下午打卡开始时间
                                userDefaults.setObject(entity?.pmCardEnd, forKey:"pmCardEnd")//下午打卡结束时间
                                
                                //登录成功设置应用程序别名
                                JPUSHService.setAlias("\(entity!.memberId!)", callbackSelector: nil, object:nil)
                                NSLog("别名是-\(entity?.memberId)")
                                
                                let app=UIApplication.sharedApplication().delegate as! AppDelegate
                                let vc = salesmanViewController()
                                app.window?.rootViewController=UINavigationController(rootViewController: vc)
                            }
                            
                            //写入磁盘
                            userDefaults.synchronize()
                            
                            let memberid=userDefaults.objectForKey("memberId") as? String
                            print(memberid)
                            
                        }else{
                            SVProgressHUD.showErrorWithStatus("账号或密码错误")
                        }
                    }
                }
            }
            
        }
    }
}