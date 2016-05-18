//
//  CardRecordViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/27.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import ObjectMapper
class CardRecordViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    //table
    private var table:UITableView!
    
    /// 集合
    var entitys:[CardEntity]=[]
    
    
    var entityes:[SummaryEntity]=[]
    /// 业务员id
    var memberID:Int!
    
    /// 起始时间
    var fdTimeSta:UITextField!
    
    /// 截止时间
    var fdTimeEnd:UITextField!
    
    /// 搜索按钮
    var btSearch:UIButton!
    
    var TimeSelect:UIDatePicker?
    
    /// 判断页面的tags(0:打卡记录  1:工作总结)
    var tags:Int!
    
    /// 输入框的tag
    var tag:Int!
    
    /// 打卡请求地址
    let queryCardURL = "queryCard.zs"
    /// 总结请求地址
    let querySummary = "querySummary.zs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        if self.tags==0{
            queryCard(queryCardURL,flag: 0)
        }else{
            queryCard(querySummary,flag: 1)
        }
    }
    
    //创建table
    func setTable(){
        table=UITableView(frame: self.view.bounds, style: .Grouped)
        table?.delegate=self
        table?.dataSource=self
        table?.tableFooterView=UIView()
        //去15px空白线
        if(table!.respondsToSelector("setLayoutMargins:")){
            table?.layoutMargins=UIEdgeInsetsZero
        }
        if(table!.respondsToSelector("setSeparatorInset:")){
            table!.separatorInset=UIEdgeInsetsZero;
        }
        
        self.view.addSubview(table!)
    }
    
    func setCell(model:CardEntity) -> UIView{
        
        let cellView=UIView(frame: CGRectMake(0,0,WIDTH,80))
        cellView.backgroundColor=UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        //日期
        let date=UILabel()
        cellView.addSubview(date)
        if let text=model.cardDate{
            date.text="打卡日期:"+text
        }
        date.font=UIFont.systemFontOfSize(15)
        date.snp_makeConstraints{(this) -> Void in
            this.centerX.equalTo(cellView)
            this.top.equalTo(cellView).offset(5)
            this.height.equalTo(20)
            this.width.equalTo(WIDTH)
        }
        date.textAlignment=NSTextAlignment.Center
        date.backgroundColor=UIColor.whiteColor()
        
        //上午
        let am=UILabel()
        cellView.addSubview(am)
        let amTimes=(model.amCardTime) ?? ""
        let amAddree=(model.amAddress) ?? ""
        var amTime=""
        if amTimes.characters.count>9{
            amTime=(String((amTimes as NSString).substringFromIndex(11))) ?? ""
        }else{
            amTime="没打卡"
        }
        am.text="  上午: "+amTime+" "+amAddree
        am.font=UIFont.systemFontOfSize(14)
        am.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(date.snp_bottom).offset(5)
            this.height.equalTo(20)
            this.width.equalTo(WIDTH)
        }

        
        //下午
        let pm=UILabel()
        cellView.addSubview(pm)
        let pmTimes=(model.pmCardTime) ?? ""
        let pmAddress=(model.pmAddress) ?? ""
        var pmTime=""
        if pmTimes.characters.count>9{
            pmTime=(String((pmTimes as NSString).substringFromIndex(11))) ?? ""
        }else{
            pmTime="没打卡"
        }
        pm.text="  下午: " + pmTime + " " + pmAddress
        pm.snp_makeConstraints{(this) -> Void in
            this.top.equalTo(am.snp_bottom).offset(3)
            this.height.equalTo(20)
            this.width.equalTo(WIDTH)
        }
        pm.font=UIFont.systemFontOfSize(14)
        
        return cellView
    }
    func setCells(model:SummaryEntity) -> UIView{
        let cellView=UIView(frame: CGRectMake(0,0,WIDTH,80))
        
        let topText:String="提交日期："
        let downText:String="总结内容："
        let cellTop=UIView(frame: CGRectMake(0,0,WIDTH,40))
        cellView.addSubview(cellTop)
        cellTop.backgroundColor=UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        
        //cell日期文字
        let cellTopLab=UILabel(frame: CGRectMake(10,10,WIDTH-10,20))
        cellTop.addSubview(cellTopLab)
        if let text=model.summaryTime{
            cellTopLab.text=topText+text
        }
        cellTopLab.font=UIFont.systemFontOfSize(14)
        
        let cellDown=UIView(frame: CGRectMake(0,40,WIDTH,40))
        cellView.addSubview(cellDown)
        cellDown.backgroundColor=UIColor.whiteColor()
        
        //cell地址文字
        let cellDownLab=UILabel(frame: CGRectMake(10,10,WIDTH-10,20))
        cellDown.addSubview(cellDownLab)
        cellDownLab.font=UIFont.systemFontOfSize(14)
        if let address=model.summaryContent{
            cellDownLab.text=downText+address
        }
        
        return cellView
    }

    //创建搜索设置栏
    func setSearch() -> UIView{
        let searchView=UIView(frame: CGRectMake(0,0,WIDTH,60))
        searchView.backgroundColor=UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        let qs=UILabel()
        qs.text="起始"
        searchView.addSubview(qs)
        qs.font=UIFont.systemFontOfSize(15)
        qs.snp_makeConstraints{(this) -> Void in
            this.left.equalTo(searchView).offset(10)
            this.centerY.equalTo(searchView)
            this.height.equalTo(20)
        }
        
        //起始时间
        fdTimeSta=UITextField()
        fdTimeSta.backgroundColor=UIColor.whiteColor()
        fdTimeSta.font=UIFont.systemFontOfSize(14)
        fdTimeSta.layer.cornerRadius=5
        fdTimeSta.tag=1
        fdTimeSta.layer.masksToBounds=true
        fdTimeSta.addTarget(self, action: "SelectorAge:", forControlEvents: .EditingDidBegin)
        searchView.addSubview(fdTimeSta)
        fdTimeSta.snp_makeConstraints{(this) -> Void in
            this.left.equalTo(qs.snp_right).offset(5)
            this.centerY.equalTo(searchView)
            this.height.equalTo(30)
            this.width.equalTo(90)
        }
        
        
        let jiezhi=UILabel()
        jiezhi.text="截止"
        searchView.addSubview(jiezhi)
        jiezhi.font=UIFont.systemFontOfSize(15)
        jiezhi.snp_makeConstraints{(this) -> Void in
            this.left.equalTo(fdTimeSta.snp_right).offset(5)
            this.centerY.equalTo(searchView)
            this.height.equalTo(20)
        }
        
        //截止时间
        fdTimeEnd=UITextField()
        searchView.addSubview(fdTimeEnd)
        fdTimeEnd.backgroundColor=UIColor.whiteColor()
        fdTimeEnd.font=UIFont.systemFontOfSize(14)
        fdTimeEnd.layer.cornerRadius=5
        fdTimeEnd.tag=2
        fdTimeEnd.layer.masksToBounds=true
        fdTimeEnd.addTarget(self, action: "SelectorAge:", forControlEvents: .EditingDidBegin)
        fdTimeEnd.snp_makeConstraints{(this) -> Void in
            this.left.equalTo(jiezhi.snp_right).offset(5)
            this.centerY.equalTo(searchView)
            this.height.equalTo(30)
            this.width.equalTo(90)
        }
        fdTimeEnd.textAlignment=NSTextAlignment.Center
        fdTimeSta.textAlignment=NSTextAlignment.Center
        
        
        //搜索按钮
        btSearch=UIButton()
        btSearch.backgroundColor=UIColor.applicationMainColor()
        btSearch.setTitle("搜索", forState: .Normal)
        searchView.addSubview(btSearch)
        btSearch.titleLabel?.font=UIFont.systemFontOfSize(14)
        btSearch.addTarget(self, action: "clickBt:", forControlEvents: .TouchUpInside)
        btSearch.snp_makeConstraints{(this) -> Void in
            this.right.equalTo(searchView.snp_right).offset(-10)
            this.centerY.equalTo(searchView)
            this.width.equalTo(50)
            this.height.equalTo(30)
        }
        btSearch.layer.cornerRadius=5
        btSearch.layer.masksToBounds=true

        
        return searchView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //返回多少个
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return 1
        }else{
            if self.tags==0{
                return entitys.count
            }else{
                return entityes.count
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let celled="cells\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(celled)
        if cell==nil{
            cell=UITableViewCell(style: .Default, reuseIdentifier: celled)
            cell=UITableViewCell(style: .Default, reuseIdentifier: celled)
            if indexPath.section==0{
                let searchV=setSearch()
                cell?.contentView.addSubview(searchV)
                
            }else{

            if self.tags==0{
                    let entity=entitys[indexPath.row]
                    let cellsView=setCell(entity)
                    cell?.contentView.addSubview(cellsView)
            }else{
                let entity=entityes[indexPath.row]
                let cellsView=setCells(entity)
                cell?.contentView.addSubview(cellsView)
                }
            }
        }
        //去除15px的空白线
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        ///取消点击效果（如QQ空间）
        cell?.selectionStyle=UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    //点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("点了点了")
    }
    
    //请求,0-打卡记录,1-工作总结
    func queryCard(url:String,flag:Int){
        let urls=URL + url
        let ID=(self.memberID) ?? 0
        
        request(.POST, urls, parameters: ["memberId":ID,"number":5]).responseJSON{res in
            if let _=res.result.error{
                SVProgressHUD.showInfoWithStatus("服务器异常")
            }
            if let value=res.result.value{
                self.entityes.removeAll()
                self.entitys.removeAll()
                let result=JSON(value)
                for (_,values) in result{
                    if flag == 0{
                        let model = Mapper<CardEntity>().map(values.object)
                        if let models=model{
                            self.entitys.append(models)
                        }
                    }else{
                        let model = Mapper<SummaryEntity>().map(values.object)
                        if let models=model{
                            self.entityes.append(models)
                        }
                    }
                    NSLog( "entitys....-\(self.entitys)")
                }
                self.table.reloadData()
            }
        }
    }
    
    
    //输入框 点击事件
    func SelectorAge(sender:UITextField){
        ///点击提醒时间事件
        self.tag=sender.tag
        TimeSelect=UIDatePicker()
        TimeSelect!.datePickerMode=UIDatePickerMode.Date;
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
        let timeZone=NSTimeZone.systemTimeZone();
        let seconds=timeZone.secondsFromGMTForDate(Timedate);
        let newDate=Timedate.dateByAddingTimeInterval(Double(seconds));
        formatter.dateFormat="yyyy-MM-dd"
        let timeStr:NSString=formatter.stringFromDate(Timedate)
        
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        timeFormatter.dateFormat = "yyyy-MM-dd" //(格式可俺按自己需求修整)
        let strNowTime:NSString = timeFormatter.stringFromDate(date)
        //        let nowTime = calendar.components([.Hour,.Minute,.Second], fromDate: date)
        let selectTime = calendar.components([.Year,.Month,.Day], fromDate: Timedate)
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        //        let years=nowTime.year-selectTime.year
        //        let months=nowTime.month-selectTime.month
        //        let days=nowTime.day-selectTime.day
        let YY=(selectTime.year) ?? 0
        let MM=(selectTime.month) ?? 0
        let DD=(selectTime.day) ?? 0
        var textTime:String!
        var textMM:String=String(MM)
        var textDD:String=String(DD)
        
        if MM<10{
            textMM="0"+String(MM)
        }else if DD<10{
            textDD="0"+String(DD)
        }
        textTime=String(YY)+"-"+textMM+"-"+textDD
        if self.tag==1{
            fdTimeSta.text=textTime
        }else if self.tag==2{
            fdTimeEnd.text=textTime
        }
        sender.maximumDate=formatter.dateFromString(String(strNowTime))
        
    }
    
    func clickBt(sender:UIButton){
        if self.tags==0{
            cardClickBt(queryCardURL,flag: 0)
        }else{
            cardClickBt(querySummary,flag: 1)
        }
    }
    //搜索事件
    func cardClickBt(url:String,flag:Int){
        //判空
        if fdTimeSta.text?.characters.count <= 0{
           SVProgressHUD.showInfoWithStatus("请输入起始时间")
            return
        }
        if fdTimeEnd.text?.characters.count <= 0{
            SVProgressHUD.showInfoWithStatus("请输入截止时间")
            return
        }
        
        /// 比较时间(截止时间要大于起始时间)
        if !contrastTime(){
            SVProgressHUD.showInfoWithStatus("截止时间要大于起始时间")
            return
        }
        
        if IJReachability.isConnectedToNetwork(){
            SVProgressHUD.showWithStatus("正在查询中...", maskType: .Clear)
            btSearch.enabled = false
            let URLs = URL + url
            let startTime = fdTimeSta.text!
            let endTime = fdTimeEnd.text!
            let parame=["memberId":"\(self.memberID)","startTime":"\(startTime)","endTime":"\(endTime)"]
            request(.POST, URLs, parameters: parame).responseJSON{res in
                if let _ = res.result.error{
                    SVProgressHUD.showErrorWithStatus("服务器异常")
                    self.btSearch.enabled = true
                }
                if let value = res.result.value{
                    self.btSearch.enabled = true
                    SVProgressHUD.dismiss()
                    self.entitys.removeAll()
                    self.entityes.removeAll()
                    let jsonResult = JSON(value)
                    for(_,values)in jsonResult{
                        if flag == 0{
                            let model = Mapper<CardEntity>().map(values.object)
                            if let models=model{
                                self.entitys.append(models)
                            }
                        }else{
                            let model = Mapper<SummaryEntity>().map(values.object)
                            if let models=model{
                                self.entityes.append(models)
                            }
                        }

                        
                    }
                    self.btSearch.enabled = true
                    self.table.reloadData()
                }
            }
            
        }else{
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
    
    
    /// 比较时间(截止时间要大于起始时间)
    func contrastTime() -> Bool{
        let startTime=fdTimeSta.text!
        let startTimeyear=Int((startTime as NSString).substringWithRange(NSMakeRange(0, 4)))
        let startTimeMouth=Int((startTime as NSString).substringWithRange(NSMakeRange(5, 2)))
        let startTimeDay=Int((startTime as NSString).substringWithRange(NSMakeRange(8, 2)))
        let endTime=fdTimeEnd.text!
        let endTimeyear=Int((endTime as NSString).substringWithRange(NSMakeRange(0, 4)))
        let endTimeMouth=Int((endTime as NSString).substringWithRange(NSMakeRange(5, 2)))
        let endTimeDay=Int((endTime as NSString).substringWithRange(NSMakeRange(8, 2)))
        
        let year = endTimeyear! - startTimeyear!
        let mouth = endTimeMouth! - startTimeMouth!
        let day = endTimeDay! - startTimeDay!
        var bools:Bool!
        if year>0{
            
        }else if year == 0{
            if mouth<0{
                bools = false
            }else if mouth==0{
                if day>0{
                    bools = true
                }else{
                   bools = false
                }
            }else{
                bools = true
            }
        }else{
            bools = false
        }
        return bools
    }
}