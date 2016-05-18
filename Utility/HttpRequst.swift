//
//  HttpRequst.swift
//  palmBusiness
//
//  Created by nevermore on 16/4/25.
//  Copyright © 2016年 hzw. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import Alamofire
import SVProgressHUD

class HttpRequst: NSObject {
    
    var jsonResult:JSON?
    
    func Http_JSON(https:String,Parameter:Dictionary<String, NSObject>) -> JSON?{
        
        
        request(.GET, URL+https, parameters: Parameter).responseJSON{ress in
            if ress.result.error != nil{
                SVProgressHUD.showErrorWithStatus("服务器异常!")
            }
            if ress.result.value != nil{
                //解析json
                self.jsonResult = JSON(ress.result.value!)
                
            
        
        }
        
        
        
    }
    
    return jsonResult ?? ""
    }
    
}