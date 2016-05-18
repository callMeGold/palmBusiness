//
//  Color+Extension.swift
//  touchForClient
//
//  Created by 卢洋 on 16/3/15.
//  Copyright © 2016年 湖南纵览天下网络科技有限公司. All rights reserved.
//

import UIKit

extension UIColor{
    
    ///主题色
    class func applicationMainColor() -> UIColor {
        return  colorWith255RGB(255, g: 80, b: 0)
    }
    /// window和BaseViewController颜色
    class func v2_backgroundColor() ->UIColor {
        return colorWith255RGB(242, g: 243, b: 245)
    }
    /// v2_navigationBarTintColor
    class func v2_navigationBarTintColor() -> UIColor{
        return colorWith255RGB(102, g: 102, b: 102)
    }
    /// v2_TopicListTitleColor
    class func v2_TopicListTitleColor() -> UIColor{
        return colorWith255RGB(15, g: 15, b: 15)
    }
    /// v2_TopicListDateColor 文字灰色
    class func v2_TopicListDateColor() -> UIColor{
        return colorWith255RGB(173, g: 173, b: 173)
    }
    
    /// 边框颜色
    class func v2_BorderColor() ->UIColor{
        return UIColor(red:221/255, green:221/255, blue:221/255, alpha:1);
    }
    /// 文字颜色
    class func textColor() ->UIColor {
        return UIColor(red: 104/255, green:104/255, blue:104/255, alpha: 1.0);
    }
    //商品价格颜色
    class func goodPriceColor() ->UIColor {
        return UIColor(red:225/255, green:45/255, blue:45/255, alpha:1)
    }
    /// 边框颜色
    class func borderColor() ->UIColor {
        return UIColor(red:143/255, green:143/255, blue:143/255, alpha: 1.0);
    }
    /// 随机色
    class func randomColor() -> UIColor{
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 0.9)
    }
    
    /// 随机值
    private class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255
    }
    
}

    /**
     RGB
     - parameter r: red
     - parameter g: grenn
     - parameter b: blue
     
     - returns: UIColor
     */
    func colorWith255RGB(r:CGFloat , g:CGFloat, b:CGFloat) ->UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 255)
    }
    /**
     RGBA(有透明度)
     - parameter r: red
     - parameter g: grenn
     - parameter b: blue
     
     - returns: UIColor
     */
    func colorWith255RGBA(r:CGFloat , g:CGFloat, b:CGFloat,a:CGFloat) ->UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255)
    }

    /**
     绘制图片
     - parameter color: UIColor
     - returns: UIImage
     */
    func createImageWithColor(color:UIColor) -> UIImage{
        return createImageWithColor(color, size: CGSizeMake(1, 1))
    }
    /**
     绘制图片大小
     - parameter color: UIColor
     - parameter size:  CGSize
     - returns: UIImage
     */
    func createImageWithColor(color:UIColor,size:CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return theImage
    }
