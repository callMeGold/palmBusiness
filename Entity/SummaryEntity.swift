//
//  SummaryEntity.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/20.
//  Copyright © 2016年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper

//会员总结
class SummaryEntity: BaseModel {
    
    var summaryId:Int?;
    var memberId:Int?;	//会员ID
    var summaryContent:String?;	//总结内容
    var summaryTime:String?;	//提交总结时间
    
    //重写父类方法，映射
    override func mapping(map: Map) {
        memberId <- map["memberId"]
        summaryId <- map["summaryId"]
        summaryContent <- map["summaryContent"]
        summaryTime <- map["summaryTime"]
        
    }
    
}