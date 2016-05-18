//
//  salesmanViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/21.
//  Copyright © 2016年 hzw. All rights reserved.
//


import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

//业务员主页面
class salesmanViewController: UIViewController,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{
    
    /// 上部父容器
    private var topImg:UIView?
    
    /// 上部LAB父容器
    private var topView:UIView?
    
    /// 公司名：会员名
    var labMemberInfo:UILabel?
    
    /// di地址信息
    var labAdree:UILabel?
    
    /// 时间上的提示
    private var labTipTime:UILabel?
    
    /// 拜访按钮
    var btVisit:UIButton?
    
    /// 客户记录按钮
    var btRecord:UIButton?
    
    ///打卡按钮
    var btClock:UIButton?
    
    ///工作总结按钮
    var btSummary:UIButton?
    
    ///我的同事按钮
    var btWorkmate:UIButton?
    
    ///下部 父视图
    var downView:UIView?
    
    /// 导航栏右边按钮
    var btRight:UIButton!
    
    //定位服务
    var _locService:BMKLocationService!
    
    //搜索服务
    var _geocodesearch:BMKGeoCodeSearch!
    
    //经度
    var _longitude:CLLocationDegrees?
    
    //纬度
    var _latitude:CLLocationDegrees?
    
    //用经纬度反编译成地址信息
    var option:BMKReverseGeoCodeOption!
    
    /// 地址信息
    var addressInfo = ""
    
    /// 左边公告按钮
    var leftBtn:UIBarButtonItem?
    
    //页面周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocation()
        
        //上部布局
        topInit()
        
        //上部lab布局
        topLab()
        
        //下部布局
        downInit()
        
        //导航栏
        navigation()
        
        //监听管理员通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploadLocation:", name: "getLocationNotification", object: nil)
        
        getCarTime()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _locService.delegate=nil
        _geocodesearch.delegate = nil
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _locService.delegate=self
        
    }
    
    //导航栏
    func navigation(){
        //导航栏右边按钮
        btRight=UIButton(frame: CGRectMake(0,0,20,20))
        btRight.setBackgroundImage(UIImage(named: "setting"), forState: UIControlState.Normal)
        btRight.addTarget(self, action: "clickBt:", forControlEvents: .TouchUpInside)
        btRight.tag=6
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: btRight)
        
        //左边按钮
        leftBtn = UIBarButtonItem(title: "查看公告", style: UIBarButtonItemStyle.Plain, target: self, action: "getCompanyNotice")
        leftBtn?.tintColor = UIColor.applicationMainColor()
        self.navigationItem.leftBarButtonItem = leftBtn
    }

    //上部布局
    func topInit(){
        self.view.backgroundColor=UIColor.whiteColor()
        self.title="业务员"
        /// 上部父视图
        topImg=UIView(frame: CGRectMake(0,64, WIDTH, 160))
        self.view.addSubview(topImg!)
        
        /// 上部背景图
        let topImage:UIImageView=UIImageView()
        topImage.frame=CGRectMake(0,0, WIDTH, 160)
        topImage.image=UIImage(named: "index_first")
        topImg?.addSubview(topImage)
        
    }
    
    //上部lab布局
    func topLab(){
        /// 上部LAB父容器
        topView=UIView(frame: CGRectMake(15,10,WIDTH-30,CGRectGetHeight(topImg!.frame)-20))
        topView?.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        topView?.layer.cornerRadius=6
        topImg?.addSubview(topView!)
        
        //欢迎使用掌上业务
        let welcome:UILabel=setLabel("欢迎使用掌上业务", labY: 10)
        topView?.addSubview(welcome)
        
        //这里是公司名：会员的名字
        let companyName = (userDefaults.objectForKey("companyName") as? String) ?? ""
        let userName = (userDefaults.objectForKey("realName") as? String) ?? ""
        labMemberInfo=setLabel(companyName + " : " + userName, labY: CGRectGetMaxY(welcome.frame)+5)
        topView?.addSubview(labMemberInfo!)
        
        //长沙市天心区水竹街1号
        labAdree=setLabel("长沙市天心区水竹街1号", labY: CGRectGetMaxY(labMemberInfo!.frame)+5)
        topView?.addSubview(labAdree!)
        
        //本公司将于6:00点到17:00点
        labTipTime=setLabel("本公司将于6:00点到17:00点", labY: CGRectGetMaxY(labAdree!.frame)+5)
        topView?.addSubview(labTipTime!)
        
        //每一个小时对你的位置定位 请保持网络通畅
        let labTips:UILabel=setLabel("每一个小时对你的位置定位,请保持网络通畅", labY: CGRectGetMaxY(labTipTime!.frame)+5)
        topView?.addSubview(labTips)
    }
    
    //创建Label
    func setLabel(labText:String,labY:CGFloat) -> UILabel{
        let lab:UILabel=UILabel(frame: CGRectMake(5,labY,WIDTH-40,20))
        lab.text=labText
        lab.font=UIFont.systemFontOfSize(14)
        lab.textColor=UIColor.whiteColor()
        return lab
    }
    
    //下部视图布局
    func downInit(){
        //父视图
        downView=UIView(frame: CGRectMake(10,CGRectGetMaxY(topImg!.frame)+15,WIDTH-20,HEIGHT-64-160-30))
        downView?.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(downView!)
        
        /// 拜访按钮
        btVisit=setBt(1, image: UIImage(named: "index_khbf"))
        downView?.addSubview(btVisit!)
        btVisit?.snp_makeConstraints{(make) -> Void in
            make.top.left.equalTo(downView!)
            make.height.equalTo(CGRectGetHeight(downView!.frame)/2-5)
            make.width.equalTo(CGRectGetWidth(downView!.frame)/2-5)
        }
        
        /// 客户记录按钮
        btRecord=setBt(2, image: UIImage(named: "index_khjl"))
        downView?.addSubview(btRecord!)
        btRecord?.snp_makeConstraints{(make) -> Void in
            make.top.right.equalTo(downView!)
            make.height.equalTo(CGRectGetHeight(downView!.frame)/2-5)
            make.width.equalTo(CGRectGetWidth(downView!.frame)/2-5)
        }
        
        
        ///工作总结按钮
        btSummary=setBt(4, image: UIImage(named: "index_gzzj"))
        downView?.addSubview(btSummary!)
        btSummary?.snp_makeConstraints{(make) -> Void in
            make.bottom.left.equalTo(downView!)
            make.height.equalTo(CGRectGetHeight(downView!.frame)/2-5)
            make.width.equalTo(CGRectGetWidth(downView!.frame)/2-5)
        }
        
        ///我的同事按钮
        btWorkmate=setBt(5, image: UIImage(named: "index_wdts"))
        downView?.addSubview(btWorkmate!)
        btWorkmate?.snp_makeConstraints{(make) -> Void in
            make.right.bottom.equalTo(downView!)
            make.height.equalTo(CGRectGetHeight(downView!.frame)/2-5)
            make.width.equalTo(CGRectGetWidth(downView!.frame)/2-5)
        }
        
        ///打卡按钮
        btClock=setBt(3, image: UIImage(named: "index_daka"))
        downView?.addSubview(btClock!)
        btClock?.snp_makeConstraints{(make) -> Void in
            make.center.equalTo(downView!)
            make.height.width.equalTo(CGRectGetHeight(downView!.frame)/3+10)
        }

    }
    
    //创建BT
    func setBt(btTag:Int,image:UIImage!) -> UIButton{
        let bt:UIButton=UIButton()
        bt.setBackgroundImage( image, forState: .Normal)
        bt.tag=btTag
        bt.addTarget(self, action: "clickBt:", forControlEvents: .TouchUpInside)
        return bt
    }
    
    func clickBt(sender:UIButton){
        if sender.tag==1{/// 拜访按钮
            
            let vc=VisitViewController()
            vc.title="客户拜访"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag==2{/// 客户记录按钮
            
            let vc=RecordViewController()
            vc.title="客户记录"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag==3{///打卡按钮
            memberCard()
        }else if sender.tag==4{///工作总结按钮
            
            let vc=SummaryViewController()
            vc.title="工作总结"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag==5{ ///我的同事按钮
            
            let vc=WorkmateViewController()
            vc.title="我的同事"
            self.navigationController?.pushViewController(vc, animated: true)

        }else if sender.tag==6{//导航栏按钮
            
            let vc=UserSetViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    /// 业务员打卡
    func memberCard(){
        if addressInfo.characters.count > 0{
            let memberId = (userDefaults.objectForKey("memberId") as? Int) ?? 0
            let latLong = "\(_latitude!)"+","+"\(_longitude)"
            if IJReachability.isConnectedToNetwork(){
                
                SVProgressHUD.showInfoWithStatus("正在打卡...")
                request(.POST, URL + "memberCard.zs", parameters: ["memberId":memberId,"address":addressInfo,"latLong":latLong], encoding: .URL).responseJSON{res in
                    if let _ = res.result.error{
                        SVProgressHUD.showInfoWithStatus("服务器异常")
                    }
                    if let value = res.result.value{
                        let jsonResult = JSON(value)
                        if jsonResult["success"] == "success"{
                            SVProgressHUD.showSuccessWithStatus("打卡成功")
                        }else if jsonResult["success"] == "amCardTime"{
                            SVProgressHUD.showErrorWithStatus("上午时间不对，不能打卡")
                        }else if jsonResult["success"] == "pmCardTime"{
                            SVProgressHUD.showErrorWithStatus("下午时间不对，不能打卡")
                        }else{
                            SVProgressHUD.showErrorWithStatus("打卡失败")
                        }
                    }else{
                        SVProgressHUD.dismiss()
                    }
                }
                
            }else{
                SVProgressHUD.showErrorWithStatus("请检查你的网络")
            }
        }else{
            SVProgressHUD.showInfoWithStatus("正在获取位置信息...")
        }
    }
    /// 获取打卡时间和
    func getCarTime(){
        let URLs = URL + "queryCompanyInfo.zs"
        let companydId = (userDefaults.objectForKey("companyId") as? Int) ?? 0
        request(.POST, URLs, parameters: ["companyId":companydId], encoding: .URL).responseJSON{res in
            if let _ = res.result.error{
                SVProgressHUD.showInfoWithStatus("服务器异常")
            }
            if let value = res.result.value{
                let jsonResult = JSON(value)
                //上午打卡时间
                let amCardStart = jsonResult["amCardStart"].stringValue
                //下午打卡时间
                let pmCardEnd = jsonResult["pmCardEnd"].stringValue
                self.labTipTime?.text! = "本公司将于" + amCardStart + "-" + pmCardEnd
            }
        }
    }
    /// 弹出公司公告
    func getCompanyNotice(){
        let URLs = URL + "queryCompanyInfo.zs"
        let companydId = (userDefaults.objectForKey("companyId") as? Int) ?? 0
        request(.POST, URLs, parameters: ["companyId":companydId], encoding: .URL).responseJSON{res in
            if let _ = res.result.error{
                SVProgressHUD.showInfoWithStatus("服务器异常")
            }
            if let value = res.result.value{
                let jsonResult = JSON(value)
                let announcement = jsonResult["announcement"].stringValue
                EZAlertController.alert("公告", message: announcement)
            }
        }
    }
}
/// MARK - 定位相关
extension salesmanViewController{
    //定位
    func setLocation(){
        //初始化BMKLocationService
        _locService = BMKLocationService()
        _locService.desiredAccuracy=kCLLocationAccuracyBest
        _locService.distanceFilter=10
        //启动LocationService
        _locService.startUserLocationService()
        //初始化
        _geocodesearch=BMKGeoCodeSearch()
        _geocodesearch.delegate=self
    }
    
    /**
     *定位失败后，会调用此函数
     *@param error 错误号
     */
    func didFailToLocateUserWithError(error:NSError!){
        SVProgressHUD.showErrorWithStatus("定位失败,请检查你的定位是否打开")
    }
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if userLocation.location != nil{//判断地址信息是否获取到  获取到后立即停止定位
            option=BMKReverseGeoCodeOption()
            //获取当前坐标
            option.reverseGeoPoint=userLocation.location.coordinate
            //获取当前坐标经纬度
            _longitude=userLocation.location.coordinate.longitude
            _latitude=userLocation.location.coordinate.latitude
            //异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetReverseGeoCodeResult通知
            NSLog("_longitude-------\(_longitude)")
            NSLog("_latitude-------\(_latitude)")
            _geocodesearch.reverseGeoCode(option)
            //立即停止定位
            _locService?.stopUserLocationService()
        }
    }
    /**
     *返回反地理编码搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetReverseGeoCodeResult(search:BMKGeoCodeSearch!,result:BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode){
        if error == BMK_SEARCH_NO_ERROR{//检索结果正常返回
            if let address = result.addressDetail{
                //省
                let _provice = address.province
                //市
                let _city = address.city
                //区
                let _district = address.district
                //街道名称
                let streetName = address.streetName
                //街道号码
                let streetNumber = address.streetNumber
                //拼接省市区字符串
                //let citys:NSArray = [_provice,_city,_district]
                addressInfo = _provice + _city + _district + streetName + streetNumber
                labAdree!.text = addressInfo
            }
        }
    }
    
    /// 当业务员接收到管理员定位请求通知后,上传自己的经纬度
    func uploadLocation(content:NSNotification){
        //获取到管理员ID和flag
        let result = content.object as! [Int]
        let flag = result[0]
        let userId = result[1]
        let memberId = (userDefaults.objectForKey("memberId") as? Int) ?? 0
        let latLong = "\(_longitude!)" + "," + "\(_latitude!)"
        if flag == 1{
            //判断定位是否成功
            let URLs = URL + "userGainMemberlatLong.zs"
            request(.GET, URLs, parameters: ["memberId":memberId,"userId":userId,"latLong":latLong], encoding: .URL)
        }else{
            let URLs = URL + "queryMemberLatLong.zs"
            request(.GET, URLs,parameters: ["memberId":memberId,"latLong":latLong])
        }
    }
}

