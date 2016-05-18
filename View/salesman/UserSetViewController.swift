//
//  UserSetViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/21.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

//用户设置
class UserSetViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    
    //table
    var table:UITableView?
    
    //cell父视图
    var cellView:UIView?
    
    //姓名
    var cellUserName:UILabel?
    
    //行高数组
    var heightArr:[CGFloat]=[60,50,20,50,50,50,30,50]
   
    /// 头像
    var headerImg:UIImageView?
    
    /// 用户ID
    let memberId = (userDefaults.objectForKey("memberId") as? Int) ?? 0
    
    /// 用户名
    let userName = (userDefaults.objectForKey("realName") as? String) ?? ""
    
    /// 会员头像
    let userPic = (userDefaults.objectForKey("portrait") as? String) ?? ""
    
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
        return 8
    }
    
    //数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cells="cell\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(cells)
        if cell==nil{
            cell=UITableViewCell(style: .Default, reuseIdentifier: cells)
            if [0,1,3,4,5].contains(indexPath.row){
                cell?.accessoryType = .DisclosureIndicator;
                let cellsView=setCell(["头像","姓名","","修改密码","版本信息","关于我们"][indexPath.row],cellHeight: heightArr[indexPath.row],Xcenter: false)
                cell?.contentView.addSubview(cellsView)
            }
            if [2,6].contains(indexPath.row){
                cell?.backgroundColor=UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
            }
            if indexPath.row==7{
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
                
                cellUserName?.text=userName
                cellUserName?.font=UIFont.systemFontOfSize(13)
            }
            if indexPath.row==0{
                headerImg=UIImageView()
                headerImg?.image=UIImage(named: "http://175.6.2.101/" + userPic)
                headerImg?.sd_setImageWithURL(NSURL(string: "http://175.6.2.101/" + userPic), placeholderImage: UIImage(named: ""))
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
    
    
    //根据索引选择拍照还是从照片库获取
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex==1{
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                //初始化图片控制器
                let picker=UIImagePickerController()
                //设置代理
                picker.delegate=self
                //指定图片控制器类型
                picker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
                //允许编辑
                picker.allowsEditing=true
                //弹出控制器，显示界面
                self.presentViewController(picker, animated: true, completion: nil)
            }else{
                SVProgressHUD.showErrorWithStatus("读取相册失败")
            }
        }else if buttonIndex==2{
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                //创建图片控制器
                let picker=UIImagePickerController()
                //设置代理
                picker.delegate=self
                //设置来源
                picker.sourceType=UIImagePickerControllerSourceType.Camera
                //允许编辑
                picker.allowsEditing=true
                //打开相机
                self.presentViewController(picker, animated: true, completion: nil)
            }
            else
            {
                SVProgressHUD.showErrorWithStatus("找不到相机")
            }
            
        }else{
            print("\(buttonIndex)")
        }
    }
    //选择图片成功之后代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image:UIImage!
        userDefaults.removeObjectForKey("portrait")
        //判断图片是否修改
        if picker.allowsEditing{
            //裁剪后图片
            image=info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            //原始图片
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        //将图片保存至本地
        //保存图片至本地，方法见下文
        self.saveImage(image, newSize: CGSize(width: 256, height: 256), percent:1, imageName: "currentImage.png")
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.stringByAppendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent("currentImage.png")
        let savedImage: UIImage = UIImage(contentsOfFile:filePath)!
        upload(
            .POST,
            URL + "commUploadImageServlet.do",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL:NSURL(fileURLWithPath:filePath), name: "filePath")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.response{  (_,response,json,error) in
                        if error != nil{
                            SVProgressHUD.showErrorWithStatus("头像修改失败")
                        }
                        if json != nil{
                            let str=NSString(data:json!, encoding:NSASCIIStringEncoding)
                            self.updateMemberPic(str!, savedImage:savedImage)
                        }
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
        //self.table?.reloadData();
    }
    //取消图片控制器代理
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //保存图片至沙盒
    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.stringByAppendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(filePath, atomically: false)
    }
    
    //修改头像
    func updateMemberPic(str:NSString,savedImage:UIImage){
        request(.GET,URL+"updateMemberInfo.zs", parameters:["memberId":memberId,"portrait":str], encoding: ParameterEncoding.URL, headers: nil).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showErrorWithStatus("头像修改失败")
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                let success=json["success"].stringValue
                if success == "success"{
                    self.headerImg!.image=savedImage
                }else{
                    SVProgressHUD.showErrorWithStatus("头像修改失败")
                }
            }
        }
    }
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row==0{//头像
            let action:UIActionSheet=UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil,otherButtonTitles:"相册","拍照")
            action.delegate=self;
            action.showInView(self.view)
        }else if indexPath.row==1{//姓名
            
        }else if indexPath.row==3{//修改密码
            let vc = RegistViewController()
            vc.title="修改密码"
            vc.tags = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==4{//版本信息
            let vc = VersionViewController()
            vc.title="版本信息"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==5{//关于我们
            let vc = AboutUs()
            vc.title="关于我们"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row==7{//退出登录
            loginOut()
            userDefaults.removeObjectForKey("memberId")
            userDefaults.synchronize()
            //点击确定 清除推送别名
            JPUSHService.setAlias("",callbackSelector:nil, object:nil)
            NSLog("清除别名成功")
            
            let app=UIApplication.sharedApplication().delegate as! AppDelegate
            let vc = LoginViewController()
            app.window?.rootViewController=UINavigationController(rootViewController: vc)
        }
        
    }
    /// 退出登录
    func loginOut(){
        let urls = URL + "loginOut.zs"
        let memberId = (userDefaults.objectForKey("memberId") as? Int) ?? 0
        request(.POST, urls, parameters: ["memberId":memberId], encoding: .URL).responseJSON{res in
            if let value = res.result.value {
                let jsonResult = JSON(value)
                if jsonResult["success"] == "success"{
                    NSLog("退出成功")
                }else{
                    NSLog("退出失败")
                }
            }
        }
    }
}