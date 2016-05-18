//
//  RecordViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/25.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import MJRefresh
import ObjectMapper

class RecordViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    //table
    var table:UITableView!
    
    /// 存储拜访客户entity
    var entitys:[ClientEntity]=[]
    
    var cellView:UIView?
    
    /// 当前页
    var currentPage = 0
    /// 条数
    var pageSize = 5
    
    var memberId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建table
        setTable()
    }
    
    //创建table
    func setTable(){
        self.view.backgroundColor=UIColor.whiteColor()
        table=UITableView(frame: self.view.bounds, style: .Plain)
        table.delegate=self
        table.dataSource=self
        table.tableFooterView=UIView()
        //去15px空白线
        if(table.respondsToSelector("setLayoutMargins:")){
            table.layoutMargins=UIEdgeInsetsZero
        }
        if(table.respondsToSelector("setSeparatorInset:")){
            table.separatorInset=UIEdgeInsetsZero;
        }
        self.view.addSubview(table)
        //加载小型菊花图
        self.showLoadingView()
        //添加头部刷新
        self.table.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] () -> Void in
            self?.entitys.removeAll()
            self!.currentPage = 1
            self?.queryClientList(self!.pageSize, currentPage: self!.currentPage)
        })
        //添加加载更多
        self.table.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] () -> Void in
            self!.currentPage = self!.currentPage + 1
            self?.queryClientList(self!.pageSize, currentPage: self!.currentPage)
        })
        //开始刷新
        self.table.mj_header.beginRefreshing()
        
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
    
    //cell标题设置
    func setCell(model:ClientEntity) -> UIView{
        cellView=UIView(frame: CGRectMake(0,0,WIDTH,90))
        
        //姓名
        let name:UILabel=UILabel(frame: CGRectMake(20,3,WIDTH,30))
        if let userName = model.clientName{
            name.text = userName
        }
        
        name.font=UIFont.systemFontOfSize(14)
        cellView?.addSubview(name)
        
        //手机
        let phone:UILabel=UILabel(frame: CGRectMake(20,32,WIDTH,30))
        if let phones = model.clientTelPhone{
            phone.text="手机: " + phones
        }
        
        phone.font=UIFont.systemFontOfSize(14)
        phone.textColor=UIColor.applicationMainColor()
        cellView?.addSubview(phone)
        
        //地址
        let adree:UILabel=UILabel(frame: CGRectMake(20,60,WIDTH,30))
        if let address = model.clientAddress{
            adree.text = "地址:" + address
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
    
    
    //查询客户记录
    func queryClientList(pageSize:Int,currentPage:Int){
        //如果有上拉加载更多 正在执行，则取消它
        if self.table!.mj_footer.isRefreshing() {
            self.table.mj_footer.endRefreshing()
        }
        if IJReachability.isConnectedToNetwork(){
            var count = 0
            let URLs = URL + "queryClientList.zs"
            // 会员ID
            if self.memberId==nil{
                memberId = (userDefaults.objectForKey("memberId") as? Int) ?? 9999
            }
            request(.POST, URLs, parameters: ["memberId":memberId!,"pageSize":pageSize,"currentPage":currentPage], encoding: .URL).responseJSON{res in
                if let _ = res.result.error{
                    self.hideLoadingView()
                    self.table.mj_header.endRefreshing()
                    self.table.mj_footer.endRefreshing()
                }
                if let value = res.result.value{
                    let jsonResult = JSON(value)
                    NSLog("客户记录:\(jsonResult)")
                    if jsonResult.count > 0{
                        for(_,value) in jsonResult{
                            count++
                            let entity=Mapper<ClientEntity>().map(value.object)
                            if let entity = entity{
                                self.entitys.append(entity)
                            }
                        }
                        if count < self.pageSize{
                            self.table.mj_footer.hidden = false
                            self.table.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            self.table.mj_footer.hidden = false
                            self.table.mj_footer.resetNoMoreData()
                        }
                        self.table.mj_header.endRefreshing()
                        self.table.reloadData()
                    }else{
                        self.table.reloadData()
                        self.table.mj_header.endRefreshing()
                        if self.entitys.count == 0{
                            self.table.mj_footer.hidden = true
                        }else{
                            self.table.mj_footer.hidden = false
                        }
                    }
                    self.hideLoadingView()
                }
            }
        }else{
            self.hideLoadingView()
            SVProgressHUD.showInfoWithStatus("请检查你的网络")
        }
    }
 
    
}