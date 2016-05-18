//
//  MemberEntity.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper

//会员实体
class MemberEntity: BaseModel {
    
    /****** 用户Id ***/
    var memberId:Int?;
    /****** 用户名 ***/
    var memberName:String?;
    /****** 密码 ***/
    var password:String?;
    /****** 真实姓名 ***/
    var realName:String?;
    /****** 性别(1,男2,女) ***/
    var gender:Int?;
    /****** 手机 ***/
    var phone_mob:String?;
    /****** 注册时间 ***/
    var regtime:String?;
    /****** 最后登录时间 ***/
    var lastLogin:String?;
    /****** 照片 ***/
    var portrait:String?;
    /****** 是否激活(1，激活，2未激活) ***/
    var activation:Int?;
    /****** 会员二维码 ***/
    var qrcode:String?;
    /****** 会员所属公司Id ***/
    var companyId:Int?;
    
    /****** 会员所属公司名称    与数据库无关 ***/
    var companyName:String?;
    
    var timeingLatlongStart:Int?;  //开始自动定位的时间
    var timeingLatlongEnd:Int?;  //结束自动定位的时间
    
    var amCardStart:String?;	//上午打卡开始时间
    var amCardEnd:String?;	//上午打卡结束时间
    var pmCardStart:String?;	//下午打卡开始时间
    var pmCardEnd:String?;	//下午打卡结束时间
    
    
    
    //重写父类方法，映射
    override func mapping(map: Map) {
        memberId <- map["memberId"]
        memberName <- map["memberName"]
        password <- map["password"]
        realName <- map["realName"]
        gender <- map["gender"]
        phone_mob <- map["phone_mob"]
        regtime <- map["regtime"]
        lastLogin <- map["lastLogin"]
        portrait <- map["portrait"]
        activation <- map["activation"]
        qrcode <- map["qrcode"]
        companyId <- map["companyId"]
        companyName <- map["companyName"]
        timeingLatlongStart <- map["timeingLatlongStart"]
        timeingLatlongEnd <- map["timeingLatlongEnd"]
        amCardStart <- map["amCardStart"]
        amCardEnd <- map["amCardEnd"]
        pmCardStart <- map["pmCardStart"]
        pmCardEnd <- map["pmCardEnd"]
        
    }
    
}