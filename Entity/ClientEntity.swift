//
//  ClientEntity.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper

///拜访客户
class ClientEntity:BaseModel{
    /// id
    var clientId:Int?
    
    /// 客户名称
    var clientName:String?;
    
    /// 客户联系方式
    var clientTelPhone:String?;
    
    /// 客户地址
    var clientAddress:String?;
    
    /// 拜访客户时间
    var clientSeeTime:String?;
    
    /// 拜访客户的会员
    var clientSeeMemberId:Int?;
    
    
    //重写父类方法，映射
    override func mapping(map: Map) {
        clientId <- map["clientId"]
        clientName <- map["clientName"]
        clientTelPhone <- map["clientTelPhone"]
        clientAddress <- map["clientAddress"]
        clientSeeTime <- map["clientSeeTime"]
        clientSeeMemberId <- map["clientSeeMemberId"]
    }
}
