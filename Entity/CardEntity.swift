//
//  File.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper

//会员打卡信息
class CardEntity:BaseModel{
    var memberId:Int?
    
    /// 早上打卡地址
    var amAddress:String?
    
    /// 早上打卡经纬度
    var amCardLatLong:String?
    
    /// 早上打卡时间
    var amCardTime:String?
    
    /// 打卡日期
    var cardDate:String?
    
    /// 下午打卡地址
    var pmAddress:String?
    
    /// 下午打卡经纬度
    var pmCardLatLong:String?
    
    /// 下午打卡时间
    var pmCardTime:String?
    
    //重写父类方法，映射
    override func mapping(map: Map) {
        memberId <- map["memberId"]
        amAddress <- map["amAddress"]
        amCardLatLong <- map["amCardLatLong"]
        amCardTime <- map["amCardTime"]
        cardDate <- map["cardDate"]
        pmAddress <- map["pmAddress"]
        pmCardLatLong <- map["pmCardLatLong"]
        pmCardTime <- map["pmCardTime"]

    }
}