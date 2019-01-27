//
//  Common.swift
//  XToolWhiteNoiseIOS
//
//  Created by 郭连城 on 2018/9/11.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

import Foundation
enum UIFontName:String {
    case pingfang_sc_light = "PingFangSC-Light"
    case pingfang_sc_medium = "PingFangSC-Medium"
    case pingfang_sc_semibold = "PingFangSC-Semibold"
    case pingfang_sc_ultralight = "PingFangSC-Ultralight"
    case pingfang_sc_regular = "PingFangSC-Regular"
    case pingfang_sc_thin = "PingFangSC-Thin"
    
    
    case century_Gothic = "CenturyGothic"
    //    family:PingFang SC
    //    font:PingFangSC-Medium
    //    font:PingFangSC-Semibold
    //    font:PingFangSC-Light
    //    font:PingFangSC-Ultralight
    //    font:PingFangSC-Regular
    //    font:PingFangSC-Thin
    
    func font(size:CGFloat)->UIFont{
        return UIFont.init(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
/// 全局字体
///
/// - Parameter size:
/// - Returns:
func preferredFont(size:CGFloat)->UIFont{
    return customFont(size: size, name: UIFontName.pingfang_sc_medium)
}

    /// 自定义字体
    ///
    /// - Parameters:
    ///   - size: <#size description#>
    ///   - name: <#name description#>
    /// - Returns: <#return value description#>
    func customFont(size:CGFloat,name:UIFontName)->UIFont{
        if let font = UIFont(name: name.rawValue, size: size){
            return font
        }else{
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    /// 打印全部字体
    func traversingFont(){
        for fontfamilyname in UIFont.familyNames
        {
            printLog("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓")
            printLog("family:\(fontfamilyname)")
            for fontName in UIFont.fontNames(forFamilyName: fontfamilyname){
                printLog("font:\(fontName)")
            }
            printLog("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑\n\n\n\n\n")
            
        }
    }

//宽度缩小系数
let widthScale = UIScreen.main.bounds.width / 375
//高度缩小系数
let heightScale = UIScreen.main.bounds.height / 667


let kWidth = UIScreen.main.bounds.width
let kHeight = UIScreen.main.bounds.height

func getTopViewControllerWithRootViewController() -> UIViewController {
    let mainvc = UIApplication.shared.keyWindow!.rootViewController
    return topViewControllerWithRootViewController(mainvc!)
}

//MARK:- 拿到当前在界面上的控制器
func topViewControllerWithRootViewController(_ rootViewController : UIViewController) -> UIViewController{
    if(rootViewController.isKind(of: UITabBarController.self)){
        let tabBarController = rootViewController as! UITabBarController
        return topViewControllerWithRootViewController(tabBarController.selectedViewController!)
    } else if(rootViewController.isKind(of: UINavigationController.self)) {
        let navigationController = rootViewController as? UINavigationController
        return topViewControllerWithRootViewController((navigationController?.visibleViewController)!)
    } else if ((rootViewController.presentedViewController) != nil) {
        let presentedViewController = rootViewController.presentedViewController
        return topViewControllerWithRootViewController(presentedViewController!)
    } else {
        return rootViewController
    }
}

func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line){
    //    #if DEBUG
    
    if let fileName = URL(string: file)?.lastPathComponent{
        print("\(fileName) \(method)[\(line)]: \(message)")
    }else{
        print("\(method)[\(line)]: \(message)")
    }
    
    
    //    #endif
}






///通知

class XYNotification:NSObject{
    ///切换控制器通知
   @objc static let switchRootViewController = "XYSwitchRootViewControllerNotification"
}

//字体
enum FontName:String {
    case centuryGothic = "Century Gothic"
}
