//
//  CompanyEntity.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper

//公司信息
class CompanyEntity: BaseModel {
    
    var companyId:Int?;
    var companyName:String?;	//公司名称
    var companyCtime:String?;	//公司注册时间
    var timeingLatlongStart:Int?;  //开始自动定位的时间
    var timeingLatlongEnd:Int?;  //结束自动定位的时间
    var companyRegister:String?;	//公司注册的标识码
    var amCardStart:String?;	//上午打卡开始时间
    var amCardEnd:String?;	//上午打卡结束时间
    var pmCardStart:String?;	//下午打卡开始时间
    var pmCardEnd:String?;	//下午打卡结束时间
    
    
    
    //重写父类方法，映射
    override func mapping(map: Map) {
        companyId <- map["companyId"]
        companyName <- map["companyName"]
        companyCtime <- map["companyCtime"]
        timeingLatlongStart <- map["timeingLatlongStart"]
        timeingLatlongEnd <- map["timeingLatlongEnd"]
        companyRegister <- map["companyRegister"]
        amCardStart <- map["amCardStart"]
        amCardEnd <- map["amCardEnd"]
        pmCardStart <- map["pmCardStart"]
        pmCardEnd <- map["pmCardEnd"]
    }

}