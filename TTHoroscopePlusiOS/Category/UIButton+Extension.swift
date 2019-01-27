//
//  UIButton+Extension.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/22.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

import Foundation
extension UIButton{
    
    convenience init(titleForState:[String:UIControl.State] = [:],
                     imageForState:[UIImage:UIControl.State] = [:],
                     backImageForState:[UIImage:UIControl.State] = [:],
                     fontName:String = "",
                     font:CGFloat = 21,
                     textAlignment:NSTextAlignment = .center,
                     cornerRadius:CGFloat = 0,
                     borderWidth:CGFloat = 0,
                     borderColor:UIColor = UIColor.black,
                     masksToBounds:Bool = false,
                     tag:Int = 0) {
        self.init()
        self.tag = tag
        for (key,value) in titleForState{
            setTitle(key, for: value)
        }
        
        for (key,value) in imageForState{
            setImage(key, for: value)
        }
        
        for (key,value) in backImageForState{
            setBackgroundImage(key, for: value)
        }
        if font != 0 {
            self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        }
        
        if !fontName.isEmpty{
             self.titleLabel?.font = UIFont(name: fontName, size: font)
        }
        self.titleLabel?.numberOfLines = 0
        
        self.titleLabel?.textAlignment = textAlignment
        
        self.layer.masksToBounds = masksToBounds
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.borderWidth = borderWidth
        
        self.layer.borderColor = borderColor.cgColor
    }
    
    
//    convenience init(titleForState:[String:UIControlState] = [:],
//                     imageForState:[UIImage:UIControlState] = [:],
//                     backImageForState:[UIImage:UIControlState] = [:],
//                     tag:Int = 0,
//                     target:Any?,
//                     action:Selector,
//                     forState:UIControlEvents){
//        self.init()
//        for (key,value) in titleForState{
//            setTitle(key, for: value)
//        }
//
//        for (key,value) in imageForState{
//            setImage(key, for: value)
//        }
//
//        for (key,value) in backImageForState{
//            setBackgroundImage(key, for: value)
//        }
//        addTarget(target, action: action, for: forState)
//    }
}

/*
class LCButton: UIButton {
    
//    func setContent(_ text:String,normalImage:String,highlightedImage:String,tag:Int,color:UIColor = Color_MainTitle){
//        self.setTitleColor(color, for: UIControlState())
//        self.setTitleColor(ME_Color, for: .highlighted)
//        self.setTitle(text.localized(), for: UIControlState())
//        self.setImage(UIImage(named:normalImage), for: UIControlState())
//        self.setImage(UIImage(named:highlightedImage), for: .highlighted)
//        self.tag = tag
//    }
    
//    convenience init(text:String,normalImage:String,highlightedImage:String,tag:Int,frame:CGRect = CGRect.zero){
//        self.init(frame: frame)
//        self.setTitleColor(Color_MainTitle, for: UIControlState())
//        self.setTitleColor(ME_Color, for: .highlighted)
//        self.setTitle(text.localized(), for: UIControlState())
//        self.setImage(UIImage(named:normalImage), for: UIControlState())
//        self.setImage(UIImage(named:highlightedImage), for: .highlighted)
//        self.tag = tag
//    }
//
    
    override init(frame: CGRect) {
        
        if frame == CGRect.zero{
            super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 80))
        }else{
            super.init(frame: frame)
        }
        addSubview(angle)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        self.isUserInteractionEnabled = true
        self.alpha = 1

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var angle : UIButton = {
        var angle = UIButton()
        angle.isHidden = true
//        angle.setBackgroundImage(buttonImageFromColor(ME_Color), for: UIControlState())
        angle.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        angle.setTitle("0", for: UIControlState())
        angle.layer.masksToBounds = true
        angle.layer.cornerRadius = 8
        angle.sizeToFit()
        return angle
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //            self.imageView!.x = 15
        //            self.titleLabel?.x = 15
        //            self.titleLabel!.y = 30
        //
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center//使图片和文字水平居中显示
        
//        contentEdgeInsets
        
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -titleLabel!.bounds.size.width)
    
        self.titleEdgeInsets = UIEdgeInsetsMake(imageView!.frame.size.height, -self.imageView!.frame.size.width, -30, 0)
        
//        self.angle.xy_centerY = titleLabel!.xy_centerY
//        self.angle.frame.origin.x = titleLabel!.frame.maxX
//        self.angle.xy_width = 16
//        self.angle.xy_height = 16
    }
}
 */
