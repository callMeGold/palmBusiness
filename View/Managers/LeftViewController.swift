//
//  LeftViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper
import SDWebImage
/// 左边视图
class LeftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    /// 接收传入的用户信息
    let tempAppDelegate=UIApplication.sharedApplication().delegate as! AppDelegate
    private var table:UITableView?
    private var titleImg=["mag_head_img","serch","setting_w","ic_launcher","yglist"]
    private var memberArr:[MemberEntity]=[]
    var txtSearch:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor(patternImage:UIImage(named: "leftbackiamge")!)
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        table!.tableHeaderView=UIView(frame:CGRectMake(0,0,self.table!.frame.width,180))
        table!.tableFooterView=UIView(frame:CGRectZero)
        self.view.addSubview(table!)
        httpUserQueryMemberInfo()
        //接收通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNickName:", name: "nickNameNotification", object: nil);
    }
    
    func updateNickName(atitle:NSNotification)
    {
        
        memberArr.removeAll()
        httpUserQueryMemberInfo()
    }
    
    func httpUserQueryMemberInfo(){
        let URLs = URL + "userQueryMemberInfo.zs"
        let companyId = (userDefaults.objectForKey("companyId") as? Int) ?? 9999
        request(.POST, URLs, parameters: ["companyId":companyId], encoding: .URL).responseJSON{res in
            if let _ = res.result.error{
                SVProgressHUD.showInfoWithStatus("服务器异常")
            }
            if let value = res.result.value{
                let jsonResult = JSON(value)
                if jsonResult.count > 0{
                    for(_,value) in jsonResult{
                        let model = Mapper<MemberEntity>().map(value.object)
                        if let models = model{
                            self.memberArr.append(models)
                        }
                    }
                    self.table?.reloadData()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=table!.dequeueReusableCellWithIdentifier("cellid")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:"cellid")
        }else{
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:"cellid")
        }
        cell!.backgroundColor=UIColor.clearColor()
        let img=UIImageView(frame:CGRectMake(15,12.5,25,25))
        cell!.contentView.addSubview(img)
        
        let name=UILabel(frame:CGRectMake(CGRectGetMaxX(img.frame)+10,15,WIDTH-CGRectGetMaxX(img.frame)+10-10,20))
        name.font=UIFont.systemFontOfSize(14)
        name.textColor=UIColor.whiteColor()
        switch indexPath.section{
        case 0:
            img.image=UIImage(named:titleImg[indexPath.row])
            switch indexPath.row{
            case 0:
                img.frame=CGRectMake(15,10,40,40)
                name.frame=CGRectMake(CGRectGetMaxX(img.frame)+10,20,WIDTH-CGRectGetMaxX(img.frame)+10-10,20)
                let cname=(userDefaults.objectForKey("companyName") as? String) ?? ""
                print(cname)
                name.text=cname
                cell!.contentView.addSubview(name)
                break
            case 1:
                txtSearch=UITextField(frame:CGRectMake(CGRectGetMaxX(img.frame)+10,10,WIDTH-CGRectGetMaxX(img.frame)+10-10,30))
                txtSearch.textColor=UIColor.whiteColor()
                cell!.contentView.addSubview(txtSearch)
                break
            case 2:
                name.text="用户设置"
                cell!.contentView.addSubview(name)
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
                break
            case 3:
                name.text="总结报表"
                cell!.contentView.addSubview(name)
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
                break
            case 4:
                name.text="员工列表"
                cell!.contentView.addSubview(name)
                break
            default:break
            }
            break
        case 1:
            
            let entity=memberArr[indexPath.row]
            let image=(entity.portrait) ?? ""
            img.sd_setImageWithURL(NSURL(string:URLIMG+image),placeholderImage:UIImage(named:"goods_default"))
            name.text=entity.realName
            cell!.contentView.addSubview(name)
            break
        default:break
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.section==0{
            if indexPath.row==2{//用户设置
                tempAppDelegate.vc?.closeLeftView()
                tempAppDelegate.pushNav!.pushViewController(ManagersUserSetViewController(), animated:true)
            }else if indexPath.row==1{//搜索
                if txtSearch.text?.characters.count>0{
                    let text = (txtSearch.text!) ?? ""
                    for (entity) in memberArr{
                        if entity.realName == text{
                            memberArr.removeAll()
                            memberArr.append(entity)
                        }
                    }
                    self.table?.reloadData()
                }else{
                    memberArr.removeAll()
                    httpUserQueryMemberInfo()
                }
            }else if indexPath.row==3{//总结报表
                let vc = SummarysViewController()
                vc.hidesBottomBarWhenPushed=true
                vc.title="总结报表"
                tempAppDelegate.vc?.closeLeftView()
                tempAppDelegate.pushNav?.pushViewController(vc, animated: true)
            }
        
        }else{
            let entity=memberArr[indexPath.row]
            let vc=DetailsViewController()
            vc.entity=entity
            tempAppDelegate.vc?.closeLeftView()
            tempAppDelegate.pushNav!.pushViewController(vc, animated:true)
        }
         //释放选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    //3.返回多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 5
        }else{
            return memberArr.count
        }
    }
    //4.返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 60
            }else{
                return 50
            }
        }else{
            return 50
        }
    }
}
