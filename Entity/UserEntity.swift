//
//  UserEntity.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper

//会员实体(管理员)
class UserEntity: BaseModel {
    
    var userID:Int?; // 会员Id
    var userName:String?; // 会员名
    var userAccount:String?; // 会员帐号
    var userPossword:String?; // 会员密码
    var ctime:String?; // 创建时间
    var flag:Int?; // 是否删除（1 未删除 2 删除）
    var companyId:Int?; // 所属公司ID
    
    /****** 会员所属公司名称 与数据库无关 ***/
    var companyName:String?;
    //重写父类方法，映射
    override func mapping(map: Map) {
        userID <- map["userID"]
        userName <- map["userName"]
        userAccount <- map["userAccount"]
        userPossword <- map["userPossword"]
        ctime <- map["ctime"]
        flag <- map["flag"]
        companyId <- map["companyId"]
        companyName <- map["companyName"]
        
    }
    
}