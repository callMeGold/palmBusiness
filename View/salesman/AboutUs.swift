//
//  AboutUs.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/24.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD

class AboutUs: UIViewController {
    
    
    let textUs="  湖南奈文摩尔网络科技有限公司成立于2015年，注册地位湖南长沙天心区，注册资本500万元，法定代表人李湘如，主要经营范围为：计算机技术开发，技术服务，游戏软件设计、制作，软件开发，电子产品研发，信息系统集成服务，计算机、软件及辅助设备等。公司自成立以来，时刻关注着软件市场的需求，以发展推动网络科技，打造智慧城市计划，公司全心致力于企业单位网络科技软件建站和电子商务的应用及推广，完善传统企业电子商务产业为使命，开发适合中国国情的行业管理软件当做自己的使命，研发出一系列管理软件互联网网络平台，满足了不同企业的需求，发起股东分别来自电子商务及网络科技行业的各个领域，具备丰富的软件开发运营经验和强有力的经济实力"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        self.view.backgroundColor=UIColor.whiteColor()
        let backImg=UIImageView()
        self.view.addSubview(backImg)
        backImg.image=UIImage(named: "logo")
        backImg.snp_makeConstraints{(make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(70)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        let downView=UILabel()
        downView.backgroundColor=UIColor.blackColor()
        downView.text=textUs
        downView.textColor=UIColor.whiteColor()
        downView.font=UIFont.systemFontOfSize(13)
        downView.numberOfLines=0
        self.view.addSubview(downView)
        downView.snp_makeConstraints{(make) -> Void in
            make.top.equalTo(backImg.snp_bottom).offset(10)
            make.width.equalTo(WIDTH-20)
            make.centerX.equalTo(self.view)
        }
        downView.layer.cornerRadius=5
        downView.layer.masksToBounds=true
        
        
        
        
        
    }
}
