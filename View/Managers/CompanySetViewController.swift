//
//  CompanySetViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/26.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD


//公司设置
class CompanySetViewController: UIViewController {
    
    /// 公司名称
    private var companyName:UILabel!
    
    /// 开始定位时间
    private var fdAm:UITextField!
    
    /// 结束定位时间
    private var fdPm:UITextField!
    
    /// 早上开始打卡时间
    private var btAmSta:UITextField!
    
    /// 早上结束打卡时间
    private var btAmEnd:UITextField!
    
    
    /// 下午开始打卡时间
    private var btPmSta:UITextField!
    
    /// 下午结束打卡时间
    private var btPmEnd:UITextField!
    
    /// 保存按钮
    private var btSave:UIButton!
    
    /// 时间选择器
    private var TimeSelect:UIDatePicker?
    
    
    //判断输入框用的
    var tag:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showUI()
    }
    
    func showUI(){
        self.view.backgroundColor=UIColor.whiteColor()
        
        //
        let gsmc=setLab("公司名称")
        self.view.addSubview(gsmc)
        gsmc.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(self.view).offset(67)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }
        
        //某某公司
        let cpName=(userDefaults.objectForKey("companyName") as? String) ?? ""
        companyName=setLab(cpName)
        self.view.addSubview(companyName)
        companyName.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(gsmc.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }
        
        //横线1
        let lineOne=setLine()
        self.view.addSubview(lineOne)
        lineOne.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(companyName.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(0.5)
            this.width.equalTo(WIDTH-30)
        }
        
        //自动定位起止时间（请输入0到23之间的整数）
        let zddwTime=setLab("自动定位起止时间（请输入0到23之间的整数）")
        self.view.addSubview(zddwTime)
        zddwTime.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(lineOne.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }

        //开始定位
        fdAm=UITextField()
        fdAm.keyboardType = .NumberPad
        fdAm.text="8"
        fdAm.font=UIFont.systemFontOfSize(14)
        self.view.addSubview(fdAm)
        fdAm.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(zddwTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view.snp_left).offset(WIDTH/4)
            this.height.equalTo(20)
            this.width.equalTo(50)
        }
        fdAm.textAlignment=NSTextAlignment.Center
        fdAm.layer.cornerRadius=5
        fdAm.layer.borderWidth=0.5
        fdAm.layer.borderColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).CGColor
        
        
        //中心连接线1
        let centerL=setLab("-")
        self.view.addSubview(centerL)
        centerL.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(zddwTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }
        
        //结束定位
        fdPm=UITextField()
        fdPm.keyboardType = .NumberPad
        fdPm.font=UIFont.systemFontOfSize(14)
        self.view.addSubview(fdPm)
        fdPm.text="18"
        fdPm.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(zddwTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view.snp_right).offset(-WIDTH/4)
            this.height.equalTo(20)
            this.width.equalTo(50)
        }
        fdPm.textAlignment=NSTextAlignment.Center
        fdPm.layer.cornerRadius=5
        fdPm.layer.borderWidth=0.5
        fdPm.layer.borderColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).CGColor

        //横线2
        let lineTwo=setLine()
        self.view.addSubview(lineTwo)
        lineTwo.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(fdAm.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(0.5)
            this.width.equalTo(WIDTH-30)
        }
        
        //废话2
        let amTime=setLab("上午打卡起止时间")
        self.view.addSubview(amTime)
        amTime.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(lineTwo.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }
        
        //上午打卡开始时间
        btAmSta=setBt("08:30:00", tags: 1)
        self.view.addSubview(btAmSta)
        btAmSta.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(amTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view.snp_left).offset(WIDTH/4)
            this.height.equalTo(20)
            this.width.equalTo(70)
        }
        
        //中心连接线2
        let centerT=setLab("-")
        self.view.addSubview(centerT)
        centerT.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(amTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }
        
        //早上终止打卡时间
        btAmEnd=setBt("10:00:00", tags: 2)
        self.view.addSubview(btAmEnd)
        btAmEnd.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(amTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view.snp_right).offset(-WIDTH/4)
            this.height.equalTo(20)
            this.width.equalTo(70)
        }
        
        //横线3
        let lineTh=setLine()
        self.view.addSubview(lineTh)
        lineTh.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btAmEnd.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(0.5)
            this.width.equalTo(WIDTH-30)
        }
        
        //废话3
        let pmTime=setLab("下午打卡起止时间")
        self.view.addSubview(pmTime)
        pmTime.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(lineTh.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
        }
        
        //下午打卡开始时间
        btPmSta=setBt("08:30:00", tags: 3)
        self.view.addSubview(btPmSta)
        btPmSta.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(pmTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view.snp_left).offset(WIDTH/4)
            this.height.equalTo(20)
            this.width.equalTo(70)
        }
        
        //中心连接线2
        let centerTh=setLab("-")
        self.view.addSubview(centerTh)
        centerTh.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(pmTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(20)
            
        }
        
        //下午-终止打卡时间
        btPmEnd=setBt("10:00:00", tags: 4)
        self.view.addSubview(btPmEnd)
        btPmEnd.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(pmTime.snp_bottom).offset(10)
            this.centerX.equalTo(self.view.snp_right).offset(-WIDTH/4)
            this.height.equalTo(20)
            this.width.equalTo(70)
        }
        
        //横线4
        let lineF=setLine()
        self.view.addSubview(lineF)
        lineF.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(btPmEnd.snp_bottom).offset(10)
            this.centerX.equalTo(self.view)
            this.height.equalTo(0.5)
            this.width.equalTo(WIDTH-30)
        }

        
        //保存按钮
        btSave=UIButton()
        btSave.setTitle("保存", forState: .Normal)
        btSave.layer.cornerRadius=5
        btSave.backgroundColor=UIColor.applicationMainColor()
        btSave.addTarget(self, action: "saveBt:", forControlEvents: UIControlEvents.TouchUpInside)
        btSave?.tag=5
        self.view.addSubview(btSave)
        btSave.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(lineF.snp_bottom).offset(20)
            this.centerX.equalTo(self.view)
            this.height.equalTo(40)
            this.width.equalTo(WIDTH-30)
        }
        
        
        
    }
    
    //创建lab
    func setLab(labText:String) -> UILabel{
        let lab=UILabel()
        lab.text=labText
        lab.font=UIFont.systemFontOfSize(14)
        lab.textAlignment=NSTextAlignment.Center
        return lab
    }
    
    //创建输入框
    func setBt(title:String,tags:Int) -> UITextField{
        let bt=UITextField()
        self.view.addSubview(bt)
        bt.text=""
        bt.tag=tags
        bt.font=UIFont.systemFontOfSize(14)
        bt.textAlignment=NSTextAlignment.Center
        bt.layer.cornerRadius=5
        bt.layer.borderWidth=0.5
        bt.layer.borderColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1).CGColor
        bt.addTarget(self, action: "SelectorAge:", forControlEvents: .EditingDidBegin)
        return bt
    }
    
    //创建横线
    func setLine() -> UIView{
        let line=UIView()
        line.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        return line
    }
    
    
    func SelectorAge(sender:UITextField){
        ///点击提醒时间事件
        self.tag=sender.tag
        TimeSelect=UIDatePicker()
        TimeSelect!.datePickerMode=UIDatePickerMode.Time;
        sender.inputView=TimeSelect
        TimeSelect!.addTarget(self, action: "dateChanged:", forControlEvents: UIControlEvents.ValueChanged)
        //2创建工具栏
        let barWarp=UIView(frame: CGRectMake(0, 0, WIDTH, 45));
        barWarp.backgroundColor=UIColor.grayColor();
        let toolbar:UIToolbar=UIToolbar(frame: CGRectMake(0, 1, WIDTH, 43));
        toolbar.backgroundColor=UIColor.whiteColor();
        //2.1创建完成按钮
        let doneItem=UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: "Check");
        doneItem.tintColor=UIColor.grayColor();
        //2.2创建空白间距
        let flexibleSpace=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        toolbar.items=[flexibleSpace,doneItem];
        barWarp.addSubview(toolbar);
        sender.inputAccessoryView=barWarp;
    }
    func Check(){
        print("完成修改")
        self.view.endEditing(true)
        
    }
    ///时间选择事件
    func dateChanged(sender:UIDatePicker){
        let Timedate:NSDate=sender.date
        let formatter=NSDateFormatter()
        //设置时区
//        let timeZone=NSTimeZone.systemTimeZone();
//        let seconds=timeZone.secondsFromGMTForDate(Timedate);
//        let newDate=Timedate.dateByAddingTimeInterval(Double(seconds));
//        formatter.dateFormat="HH:mm:ss"
//        let timeStr:NSString=formatter.stringFromDate(Timedate)
        
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        timeFormatter.dateFormat = "HH:mm:ss" //(格式可俺按自己需求修整)
//        let strNowTime:NSString = timeFormatter.stringFromDate(date)
//        let nowTime = calendar.components([.Hour,.Minute,.Second], fromDate: date)
        let selectTime = calendar.components([.Hour,.Minute,.Second], fromDate: Timedate)
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
//        let years=nowTime.year-selectTime.year
//        let months=nowTime.month-selectTime.month
//        let days=nowTime.day-selectTime.day
        let HH=(selectTime.hour) ?? 0
        let mm=(selectTime.minute) ?? 0
        var textTime:String!
        if HH>9{
            textTime=String(HH)+":"+String(mm)+":00"
        }else{
            textTime="0"+String(HH)+":"+String(mm)+":00"
        }
        
        if self.tag==1{
            btAmSta.text=textTime
        }else if self.tag==2{
            btAmEnd.text=textTime
        }else if self.tag==3{
            btPmSta.text=textTime
        }else{
            btPmEnd.text=textTime
        }

//        print("Timedate....\(Timedate)")
//        print("timeStr选中的日期\(timeStr)")
//        print("newDate新日期\(newDate)")
//        print("nowTime....\(nowTime)")
//        print("strNowTime....\(strNowTime)")
//        print("Timedate....\(Timedate)")
//        sender.maximumDate=formatter.dateFromString(String(strNowTime))
        
    }
    
    /// 保存公司设置
    func saveBt(sender:UIButton){
        if fdAm.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入自动定位开始时间")
            return
        }
        if fdPm.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入自动定位结束时间")
            return
        }
        if btAmSta.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入上午打卡开始时间")
            return
        }
        if btAmEnd.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入上午打卡结束时间")
            return
        }
        if btPmSta.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入下午打卡开始时间")
            return
        }
        if btPmEnd.text?.characters.count < 0{
            SVProgressHUD.showInfoWithStatus("请输入下午打卡结束时间")
            return
        }
        if IJReachability.isConnectedToNetwork(){
            let companyId = (userDefaults.objectForKey("companyId") as? Int) ?? 0
            let locationStart = fdAm.text!
            let locationEnd = fdPm.text!
            let amStart = btAmSta.text!
            let amEnd = btAmEnd.text!
            let pmStart = btPmSta.text!
            let pmEnd = btPmEnd.text!
            
            request(.POST, URL + "userUpdateCompanyInfo.zs", parameters: ["companyId":companyId,"timeingLatlongStart":locationStart,"timeingLatlongEnd":locationEnd,"amCardStart":amStart,"amCardEnd":amEnd,"pmCardStart":pmStart,"pmCardEnd":pmEnd], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showErrorWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    if jsonResult["success"] == "success"{
                        SVProgressHUD.showSuccessWithStatus("保存成功")
                    }else{
                        SVProgressHUD.showErrorWithStatus("保存失败")
                    }
                }
            }
            
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
        
    }
    
    
}
