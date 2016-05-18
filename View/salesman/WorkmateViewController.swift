//
//  WorkmateViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/25.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import ObjectMapper
class WorkmateViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    //table
    var table:UITableView?
    
    var entitys:[MemberEntity]=[]
    
    var cellView:UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建table
        setTable()
    }
    
    //创建table
    func setTable(){
        self.view.backgroundColor=UIColor.whiteColor()
        table=UITableView(frame: self.view.bounds, style: .Plain)
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
        self.showLoadingView()
        userQueryMemberInfo()
    }
    //返回几个
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entitys.count
    }
    
    //数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cells="cell\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(cells)
        if cell==nil{
            cell=UITableViewCell(style: .Default, reuseIdentifier: cells)
            if entitys.count > 0{
                let cellst=setCell(entitys[indexPath.row])
                cell?.contentView.addSubview(cellst)
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
    
    //cell样式设置
    func setCell(model:MemberEntity) -> UIView{
        cellView=UIView(frame: CGRectMake(0,0,WIDTH,90))
        
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
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    //点击事件
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("12")
    }
    
    /// 查询我的同事
    func userQueryMemberInfo(){
        if IJReachability.isConnectedToNetwork(){
            let URLs = URL + "userQueryMemberInfo.zs"
            let companyId = (userDefaults.objectForKey("companyId") as? Int) ?? 9999
            request(.POST, URLs, parameters: ["companyId":companyId], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    self.hideLoadingView()
                    SVProgressHUD.showInfoWithStatus("服务器异常")
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    if jsonResult.count > 0{
                        for(_,value) in jsonResult{
                            let model = Mapper<MemberEntity>().map(value.object)
                            if let models = model{
                                self.entitys.append(models)
                            }
                        }
                        self.hideLoadingView()
                        self.table?.reloadData()
                    }else{
                        self.hideLoadingView()
                    }
                }
            }
        }else{
            self.hideLoadingView()
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
}