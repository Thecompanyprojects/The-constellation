//
//  XYPalmReadingLayout.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/28.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

import UIKit
@objcMembers
class XYPalmReadingFooter:UICollectionReusableView{
    
    var btnType : XYResultType = XYResultType.notShowBtn{
        didSet{
            if btnType == XYResultType.notShowBtn{
                label.text = "Get your palm reading"
                imageView.isHidden = true;
                label.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.centerX.equalTo(self)
                }
            }else if btnType == XYResultType.showPayBtn{
                 label.text = "View full prediction with premium"
                imageView.isHidden = false;
                label.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.centerX.equalTo(self).offset(30)
                }
            }else{
                 label.text = "Watch Video To Read On"
                imageView.isHidden = false;
                label.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self)
                    make.centerX.equalTo(self).offset(30)
                }
                imageView.image = UIImage.init(named: "视频")
                let grandColor = UIColor(gradientWith: CGSize.init(width: kWidth, height: 59), direction: GradientDirection.horizontal, start: UIColor(hexString: "#FFFE4D4D"), end: UIColor(hexString:"#FFEE1919"))
                
                self.button.setBackgroundImage(nil, for: UIControl.State.normal)
                self.button.backgroundColor = grandColor;
                
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        addSubview(imageView)
        addSubview(label)
        
        label.text = "Get your palm reading"
        label.textColor = UIColor.white
        
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        let image = UIImage(named: "bt_fangxing")
        button.setBackgroundImage(image, for: UIControl.State.normal)
        let grayImage = UIImage(color: UIColor.gray)
        
        button.setBackgroundImage(grayImage, for: UIControl.State.disabled)
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.width.equalTo(25)
            make.right.equalTo(label.snp.left).offset(-10)
        }
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var button = UIButton()
    lazy var imageView = UIImageView(image: UIImage(named: "小图标 引导付费钻石"))
    lazy var label = UILabel()
}
@objcMembers
class XYPalmReadingHeader:UICollectionReusableView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(13)
            make.right.equalTo(self).offset(-13)
            make.top.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title = UILabel(title: "",
                             fontName: UIFontName.century_Gothic.rawValue,
                             textSize: 14,
                             color: UIColor.black,
                             numberOfLines: 0,
                             textAlignment: .left)
}



class XYPalmReadingLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let rowCount : CGFloat = 3
        
        
        self.sectionInset = UIEdgeInsets.init(top: 20, left: 13, bottom: 30, right: 13);
        
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = 0 //列间距
        self.minimumLineSpacing = 0//行间距
        
        let totalWidth = UIScreen.main.bounds.width - 26
        let width: CGFloat  = (totalWidth)/rowCount-0.1;
        
        
        self.itemSize = CGSize.init(width: width, height: width+20+10)
    }
}
