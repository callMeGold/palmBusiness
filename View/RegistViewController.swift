//
//  RegistViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD


//注册页面
class RegistViewController:UIViewController {
    
    /// 剩余的秒数
    var remainingSeconds: Int = 0 {
        willSet {
            btGetCode.setTitle("(\(newValue)秒后重新获取)", forState: .Normal)
            
            if newValue <= 1 {
                btGetCode.setTitle("获取验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    /// 创建实例
    var countdownTimer: NSTimer?
    /// 开启关闭倒计时
    var isCounting = false{
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
                remainingSeconds = 60
                btGetCode.setTitleColor(.grayColor(), forState: UIControlState.Normal)
            }else{
                countdownTimer?.invalidate()
                countdownTimer = nil
                btGetCode.setTitleColor(.whiteColor(), forState: UIControlState.Normal)
            }
            btGetCode.enabled = !newValue
        }
    }

    
    
    
    /// 手机号码
    private var fdNumber:UITextField?
    
    /// 手机验证码
    private var fdCode:UITextField?
    
    /// 密码
    private var fdPassWord:UITextField?
    
    /// 再次输入密码
    private var fdPassWordAgin:UITextField?
    
    /// 姓名
    private var fdUserName:UITextField?
    
    /// 公司注册码
    private var fdCompanyCode:UITextField?
    
    /// 获取验证码
    private var btGetCode:UIButton!
    
    /// 确定注册按钮
    private var btRegist:UIButton?
    
    /// 请求
    var https:HttpRequst!
    
    /// 存网络发过来的验证码
    var netCode:String?
    
    //判断（0：管理员，1：业务员）
    var tags=0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if self.title=="注册"{
            //注册页面的布局
            InitRegistUI()
        }else if self.title=="找回密码"{
            //找回密码页面的布局
            ForgetPassWordUI()
            
        }else{
            //修改密码页面的布局
            updatePassWord()
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        SVProgressHUD.dismiss()
    }
    //启动计时器
    func updateTime(){
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

    //修改密码页面的布局
    func updatePassWord(){
        /// 密码
        fdPassWord=UITextField()
        fdPassWord=fdSet(120, placeholderText: "请输入密码")
        self.view.addSubview(fdPassWord!)
        
        /// 再次输入密码
        fdPassWordAgin=UITextField()
        fdPassWordAgin=fdSet(CGRectGetMaxY(fdPassWord!.frame)+20, placeholderText: "请再次输入密码")
        self.view.addSubview(fdPassWordAgin!)
        
        //确认修改按钮
        btRegist=UIButton()
        btRegist?.frame=CGRectMake(15, CGRectGetMaxY(fdPassWordAgin!.frame)+20, WIDTH-30, 40)
        btRegist?.setTitle("确认修改", forState: .Normal)
        btRegist?.layer.cornerRadius=5
        btRegist?.backgroundColor=UIColor.applicationMainColor()
        btRegist?.addTarget(self, action: "ForgetPassWordBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btRegist?.tag=3
        self.view.addSubview(btRegist!)
        
    }
    
    //找回密码页面的布局
    func ForgetPassWordUI(){
        /// 手机号码
        fdNumber=UITextField()
        fdNumber=fdSet(75, placeholderText: "请输入手机号码")
        self.view.addSubview(fdNumber!)
        
        /// 手机验证码
        fdCode=UITextField()
        fdCode=fdSet(CGRectGetMaxY(fdNumber!.frame)+20, placeholderText: "请输入手机验证码")
        self.view.addSubview(fdCode!)
        
        //获取手机验证码按钮
        btGetCode=UIButton()
        self.view.addSubview(btGetCode!)
        btGetCode?.backgroundColor=UIColor.applicationMainColor()
        btGetCode?.layer.cornerRadius=5
        btGetCode?.setTitle("获取验证码", forState: .Normal)
        btGetCode?.setTitleColor(.whiteColor(), forState: .Normal)
        btGetCode?.addTarget(self, action: "ForgetPassWordBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btGetCode?.tag=4
        btGetCode?.titleLabel?.font=UIFont.systemFontOfSize(12)
        btGetCode?.frame=CGRectMake(WIDTH-100, CGRectGetMinY(fdCode!.frame), 85, 40)
        
        /// 密码
        fdPassWord=UITextField()
        fdPassWord=fdSet(CGRectGetMaxY(fdCode!.frame)+20, placeholderText: "请输入密码")
        self.view.addSubview(fdPassWord!)
        
        /// 再次输入密码
        fdPassWordAgin=UITextField()
        fdPassWordAgin=fdSet(CGRectGetMaxY(fdPassWord!.frame)+20, placeholderText: "请再次输入密码")
        self.view.addSubview(fdPassWordAgin!)
        
        //确认找回按钮
        btRegist=UIButton()
        btRegist?.frame=CGRectMake(15, CGRectGetMaxY(fdPassWordAgin!.frame)+20, WIDTH-30, 40)
        btRegist?.setTitle("确认找回", forState: .Normal)
        btRegist?.layer.cornerRadius=5
        btRegist?.backgroundColor=UIColor.applicationMainColor()
        btRegist?.addTarget(self, action: "ForgetPassWordBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btRegist?.tag=5
        self.view.addSubview(btRegist!)
        
    }
    
    //注册页面的布局
    func InitRegistUI(){
        /// 手机号码
        fdNumber=UITextField()
        fdNumber=fdSet(70, placeholderText: "请输入手机号码")
        self.view.addSubview(fdNumber!)
        fdNumber?.keyboardType = .NumberPad
        
        /// 手机验证码
        fdCode=UITextField()
        fdCode=fdSet(CGRectGetMaxY(fdNumber!.frame)+10, placeholderText: "请输入手机验证码")
        self.view.addSubview(fdCode!)
        fdCode?.keyboardType = .NumberPad
        
        //获取手机验证码按钮
        btGetCode=UIButton()
        self.view.addSubview(btGetCode!)
        btGetCode?.backgroundColor=UIColor.applicationMainColor()
        btGetCode?.layer.cornerRadius=5
        btGetCode?.setTitle("获取验证码", forState: .Normal)
        btGetCode?.setTitleColor(.whiteColor(), forState: .Normal)
        btGetCode?.addTarget(self, action: "ForgetPassWordBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btGetCode?.tag=1
        btGetCode?.titleLabel?.font=UIFont.systemFontOfSize(12)
        btGetCode?.frame=CGRectMake(WIDTH-100, CGRectGetMinY(fdCode!.frame), 85, 40)
        
        /// 密码
        fdPassWord=UITextField()
        fdPassWord=fdSet(CGRectGetMaxY(fdCode!.frame)+10, placeholderText: "请输入密码")
        self.view.addSubview(fdPassWord!)
        
        /// 再次输入密码
        fdPassWordAgin=UITextField()
        fdPassWordAgin=fdSet(CGRectGetMaxY(fdPassWord!.frame)+10, placeholderText: "请再次输入密码")
        self.view.addSubview(fdPassWordAgin!)
        
        /// 姓名
        fdUserName=UITextField()
        fdUserName=fdSet(CGRectGetMaxY(fdPassWordAgin!.frame)+10, placeholderText: "请输入您的姓名")
        self.view.addSubview(fdUserName!)
        
        /// 公司注册码
        fdCompanyCode=UITextField()
        fdCompanyCode=fdSet(CGRectGetMaxY(fdUserName!.frame)+10, placeholderText: "请输入公司注册码")
        self.view.addSubview(fdCompanyCode!)
        
        //提示文字
        let labTip:UILabel=UILabel()
        labTip.frame=CGRectMake(15, CGRectGetMaxY(fdCompanyCode!.frame)+10, WIDTH-30, 40)
        labTip.text="注意:如果您的公司第一次使用本软件请购买得到公司注册码之后再次进行注册"
        labTip.font=UIFont.systemFontOfSize(12)
        labTip.numberOfLines=2
        labTip.textAlignment=NSTextAlignment.Center
        self.view.addSubview(labTip)
        
        //确定注册按钮
        btRegist=UIButton()
        btRegist?.frame=CGRectMake(15, CGRectGetMaxY(labTip.frame)+10, WIDTH-30, 40)
        btRegist?.setTitle("确认注册", forState: .Normal)
        btRegist?.layer.cornerRadius=5
        btRegist?.backgroundColor=UIColor.applicationMainColor()
        btRegist?.addTarget(self, action: "ForgetPassWordBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btRegist?.tag=2
        self.view.addSubview(btRegist!)
        
    }
    
   
    
    //创建输入框
    func fdSet(Y:CGFloat,placeholderText:String) -> UITextField{
        let zoer=UIView(frame: CGRectMake(0,0,10,20))
        let fd:UITextField=UITextField()
        fd.leftView=zoer
        fd.leftViewMode=UITextFieldViewMode.Always
        fd.frame=CGRectMake(15, Y, WIDTH-30, 40)
        fd.placeholder=placeholderText
        fd.layer.borderWidth=1
        fd.font=UIFont.systemFontOfSize(14)
        fd.layer.borderColor=UIColor.applicationMainColor().CGColor
        fd.layer.cornerRadius=5
        fd.clearButtonMode=UITextFieldViewMode.WhileEditing
        return fd
    }
    
    //按钮点击事件
    func ForgetPassWordBt(sender:UIButton){
        
        let code=fdCode?.text
        let password=fdPassWord?.text
        let passwordAgin=fdPassWordAgin?.text
        let userName=fdUserName?.text
        let companyCode=fdCompanyCode?.text
        
        
        
        if sender.tag==1{//注册   获取验证码按钮
            //isCounting=true
            let name=fdNumber?.text
            if name?.characters.count>0 {
                if name?.characters.count==11 {
                    request(.POST,URL+"checkPhone.xhtml", parameters:["memberName":name!]).responseJSON{ response in
                        if response.result.error != nil{
                            SVProgressHUD.showErrorWithStatus("服务器异常")
                        }
                        if response.result.value != nil{
                            
                            SVProgressHUD.dismiss()
                            let json=JSON(response.result.value!)
                            let success=json["success"].stringValue
                            if success == "success"{
                                self.isCounting=true
                                self.netCode=json["code"].stringValue
                            }else if success == "exist"{
                                SVProgressHUD.showInfoWithStatus("账号已存在")
                            }else{
                                SVProgressHUD.showInfoWithStatus("服务器异常")
                            }
                        }
                    }
                }else{
                    SVProgressHUD.showInfoWithStatus("请输入正确的电话号码")
                    
                }
            }else{
                SVProgressHUD.showInfoWithStatus("手机号码不能为空")
            }
        }else if sender.tag==2{//注册页面-确认注册
            if code?.characters.count<1{
                SVProgressHUD.showInfoWithStatus("验证不能为空")
                return
            }else if password?.characters.count<1{
                SVProgressHUD.showInfoWithStatus("密码不能为空")
                return
            }else if passwordAgin != password{
                SVProgressHUD.showInfoWithStatus("两次密码输入不一致")
                return
            }else if userName?.characters.count<1{
                SVProgressHUD.showInfoWithStatus("姓名不能为空")
                return
            }else if companyCode?.characters.count<1{
                SVProgressHUD.showInfoWithStatus("公司注册码不能为空")
                return
            }
            if self.netCode != code{
                SVProgressHUD.showInfoWithStatus("验证码错误或已失效")
                return
            }
            doRegister()
            
        }else if sender.tag==3{//修改密码    按钮
            if tags == 0{
                updatePassword(2)
            }else{//业务员
                updatePassword(1)
            }
            
        }else if sender.tag==4{//找回密码   验证码
            isCounting=true
            if tags == 0{//管理员
                getCodeForFindPassword(2)
            }else{//业务员
                getCodeForFindPassword(1)
            }
        }else{//找回密码    确认找回按钮
            if tags == 0{
                findPassword(2)
            }else{//业务员
                findPassword(1)
            }
        }
    }
    
   
    
    /// 修改密码
    func updatePassword(flag:Int){
        var firstPassword = ""
        var secondPassword = ""
        if fdPassWord!.text?.characters.count > 0{
            firstPassword = fdPassWord!.text!
        }else{
            SVProgressHUD.showInfoWithStatus("请输入密码")
            fdPassWord?.resignFirstResponder()
            return
        }
        if fdPassWordAgin!.text?.characters.count > 0{
            secondPassword = fdPassWordAgin!.text!
        }else{
            SVProgressHUD.showInfoWithStatus("请输入密码")
            fdPassWordAgin?.resignFirstResponder()
            return
        }
        if firstPassword == secondPassword{
            if IJReachability.isConnectedToNetwork(){
                let memberName = (userDefaults.objectForKey("memberName") as? String) ?? ""
                let URLs = URL + "memberUpdatePassWord.zs"
                SVProgressHUD.showWithStatus("正在修改...", maskType: .Clear)
                request(.POST, URLs, parameters: ["memberName":memberName,"newPassword":secondPassword,"flag":flag], encoding: .URL).responseJSON{res in
                    if let _ = res.result.error{
                        SVProgressHUD.showWithStatus("服务器异常")
                    }
                    if let value = res.result.value{
                        let jsonResult = JSON(value)
                        if jsonResult["success"] == "success"{
                            SVProgressHUD.showSuccessWithStatus("修改成功")
                            self.navigationController?.popViewControllerAnimated(true)
                        }else if jsonResult["success"] ==  "memberNameNull"{
                            SVProgressHUD.showErrorWithStatus("账号不存在")
                        }else{
                            SVProgressHUD.showErrorWithStatus("修改失败")
                        }
                    }
                }
                
            }else{
                SVProgressHUD.showInfoWithStatus("请检查你的网络")
            }
        }else{
            SVProgressHUD.showInfoWithStatus("两次密码不一致")
        }
    }
    /// 注册
    func doRegister(){
        let URLs = URL + "memberRegister.zs"
        let phoneText = fdNumber!.text!
        let password = fdPassWord!.text!
        let realName = fdUserName!.text!
        let companyCode = fdCompanyCode!.text!
        if IJReachability.isConnectedToNetwork(){
            SVProgressHUD.showWithStatus("正在注册...")
            request(.POST, URLs, parameters: ["memberName":phoneText,"password":password,"companyRegister":companyCode,"realName":realName], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    if jsonResult["success"] == "success"{
                        SVProgressHUD.showSuccessWithStatus("注册成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else if jsonResult["success"] == "isexist"{
                        SVProgressHUD.showErrorWithStatus("注册码不存在")
                    }else{
                        SVProgressHUD.showErrorWithStatus("注册失败")
                    }
                    
                }else{
                   SVProgressHUD.dismiss()
                }
            }
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
    /// 找回密码页面-获取验证码
    func getCodeForFindPassword(flag:Int){
        var phoneText = ""
        if fdNumber?.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入手机号码")
            return
        }
        let URLs = URL + "checkPhoneUpdatePassWord.xhtml"
        phoneText = fdNumber!.text!
        if IJReachability.isConnectedToNetwork(){
            SVProgressHUD.showWithStatus("正在获取...")
            request(.POST, URLs, parameters: ["memberName":phoneText,"flag":flag], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    if jsonResult["success"] == "success"{
                        SVProgressHUD.dismiss()
                        self.isCounting=true
                        self.netCode=jsonResult["code"].stringValue
                    }else if jsonResult["success"] == "exist"{
                        SVProgressHUD.showErrorWithStatus("账号不存在")
                    }else{
                        SVProgressHUD.showErrorWithStatus("发送失败")
                    }
                }else{
                    SVProgressHUD.dismiss()
                }
            }
            
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络连接")
        }
    }
    /// 找回密码页面-确认找回密码
    func findPassword(flag:Int){
        var phoneText = ""
        var passWordText = ""
        if fdNumber?.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入手机号码")
            return
        }
        if fdCode?.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入验证码")
        }
        if fdCode!.text! != self.netCode{
            SVProgressHUD.showInfoWithStatus("验证码错误")
            return
        }
        if fdPassWord?.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入新的密码")
            return
        }
        if fdPassWordAgin?.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请确认密码")
            return
        }
        if fdPassWordAgin!.text! != fdPassWord!.text!{
            SVProgressHUD.showInfoWithStatus("两次密码输入不一致")
        }
        if IJReachability.isConnectedToNetwork(){
            phoneText = fdNumber!.text!
            passWordText = fdPassWord!.text!
            let URLs = URL + "memberUpdatePassWord.zs"
            SVProgressHUD.show()
            request(.POST, URLs, parameters: ["memberName":phoneText,"newPassword":passWordText,"flag":flag], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    if jsonResult["success"] == "success"{
                        SVProgressHUD.showSuccessWithStatus("修改成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else if jsonResult["success"] ==  "memberNameNull"{
                        SVProgressHUD.showErrorWithStatus("会员账号不存在")
                    }else if jsonResult["success"] ==  "usreNameNull"{
                        SVProgressHUD.showErrorWithStatus("管理员账号不存在")
                    }else{
                        SVProgressHUD.showErrorWithStatus("修改失败")
                    }
                }
            }
            
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
        
    }
}