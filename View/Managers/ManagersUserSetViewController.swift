//
//  ManagersUserSetViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/26.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

//用户设置
class ManagersUserSetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    
    //table
    var table:UITableView?
    
    //cell父视图
    var cellView:UIView?
    
    //姓名
    var cellUserName:UILabel?
    
    //行高数组
    var heightArr:[CGFloat]=[60,50,50,50,50,50,50,30,50]
    
    /// 头像
    var headerImg:UIImageView?
    
    /// 用户ID
    let memberId = (userDefaults.objectForKey("userID") as? Int) ?? 0
    
    //页面周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        self.title="用户设置"
        //创建table
        setTable()
    }
    
    func setTable(){
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
    }
    
    //返回几个
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    //数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cells="cell\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(cells)
        if cell==nil{
            cell=UITableViewCell(style: .Default, reuseIdentifier: cells)
            if [0,1,2,3,4,5,6].contains(indexPath.row){
                cell?.accessoryType = .DisclosureIndicator;
                let cellsView=setCell(["头像","姓名","修改密码","版本信息","关于我们","公司设置","公司公告"][indexPath.row],cellHeight: heightArr[indexPath.row],Xcenter: false)
                cell?.contentView.addSubview(cellsView)
            }
            if [7].contains(indexPath.row){
                cell?.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
            }
            if indexPath.row==8{
                let cellesView=setCell("退出登录", cellHeight: 50, Xcenter: true)
                cell?.contentView.addSubview(cellesView)
            }
            if indexPath.row==1{
                cellUserName=UILabel()
                cell?.contentView.addSubview(cellUserName!)
                cellUserName?.snp_makeConstraints{(make) -> Void in
                    make.right.equalTo(cell!.contentView).offset(0)
                    make.centerY.equalTo(cell!.contentView)
                }
                let name=(userDefaults.objectForKey("userName") as? String) ?? ""
                cellUserName?.text=name
                cellUserName?.font=UIFont.systemFontOfSize(13)
            }
            if indexPath.row==0{
                headerImg=UIImageView()
                headerImg?.image=UIImage(named: "app_logo")
                headerImg?.layer.cornerRadius=20
                headerImg?.layer.masksToBounds=true
                cell?.contentView.addSubview(headerImg!)
                headerImg?.snp_makeConstraints{(make) -> Void in
                    make.right.equalTo(cell!.contentView)
                    make.width.height.equalTo(40)
                    make.centerY.equalTo(cell!.contentView)
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
    
    //cell标题设置
    func setCell(labText:String,cellHeight:CGFloat,Xcenter:Bool) -> UIView{
        cellView=UIView(frame: CGRectMake(0,0,WIDTH,cellHeight))
        //cell文字
        let lab:UILabel=UILabel(frame: CGRectMake(0,0,0,0))
        lab.text=labText
        lab.font=UIFont.systemFontOfSize(14)
        cellView?.addSubview(lab)
        lab.snp_makeConstraints{(make) -> Void in
            make.centerY.equalTo(cellView!)
            if Xcenter==true{
                make.centerX.equalTo(cellView!)
            }else{
                make.left.equalTo(cellView!).offset(10)
            }
        }
        return cellView!
    }
    
    //行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightArr[indexPath.row]
    }
    
    
       //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row==1{//姓名
            
        }else if indexPath.row==2{//修改密码
            let vc = RegistViewController()
            vc.title="修改密码"
            vc.tags = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==3{//版本信息
            
            let vc = VersionViewController()
            vc.title="版本信息"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==4{//关于我们
            
            let vc = AboutUs()
            vc.title="关于我们"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==5{//公司设置
            let vc = CompanySetViewController()
            vc.title="公司设置"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==8{//退出登录
            userDefaults.removeObjectForKey("userID")
            let app=UIApplication.sharedApplication().delegate as! AppDelegate
            let vc = LoginViewController()
            app.window?.rootViewController=UINavigationController(rootViewController: vc)
        }else if indexPath.row==6{
            let vc = SetAnnouncementViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}