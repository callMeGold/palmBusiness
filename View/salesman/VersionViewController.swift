//
//  VersionViewController.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/25.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit


//版本信息
class VersionViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        self.view.backgroundColor=UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1)
        //上面视图
        let topView=UIView(frame: CGRectMake(0,64,WIDTH,100))
        topView.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(topView)
        let image=UIImageView(frame: CGRectMake(20,10,70,70))
        image.image=UIImage(named: "logo_vision")
        topView.addSubview(image)
        
        let labOld=UILabel(frame: CGRectMake(120,30,WIDTH-120,20))
        labOld.text="您的当前版本号：1.2"
        labOld.font=UIFont.systemFontOfSize(14)
        topView.addSubview(labOld)
        
        
        let labNew=UILabel(frame: CGRectMake(120,60,WIDTH-120,20))
        labNew.text="最新版本号：1.2"
        labNew.font=UIFont.systemFontOfSize(14)
        topView.addSubview(labNew)
        
    
    
    
    }
    
    
    
}
