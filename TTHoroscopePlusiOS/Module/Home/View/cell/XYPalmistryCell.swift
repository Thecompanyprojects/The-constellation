//
//  XYPalmistryCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/26.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

import UIKit
//手相引导界面
class XYPalmistryCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
    
        contentView.addSubview(backImageView)
        contentView.addSubview(textA)
        contentView.addSubview(iconImage)
        
//        backImageView.mas_makeConstraints { (make) in
//            make?.width.mas_equalTo()(kWidth-leftMargin*2)
//            make?.centerX.mas_equalTo()(self.contentView)
//            make?.top.mas_equalTo()(self.contentView)?.offset()(topMargin)
//            make?.height.mas_equalTo()((kWidth-leftMargin*2)*0.428)
//            make?.bottom.mas_equalTo()(self.contentView)?.offset()(-topMargin)
//        }
        
        backImageView.snp.makeConstraints { (make) in
            make.width.equalTo(kWidth)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(topMargin)
            make.height.equalTo(Int(kWidth*0.428))

            make.bottom.equalTo(self.contentView).offset(-topMargin)
        }
        
        textA.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView).offset(-16)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        iconImage.snp.makeConstraints { (make) in
            make.right.equalTo(textA)
            make.top.equalTo(self.textA.snp.bottom).offset(10)
        }
    }
    
    
    //MARK:- notvip lazy
    private lazy var textA : UILabel = {
        let v = UILabel(title: "Palm Reading")
        v.font = preferredFont(size: 19)
        v.isUserInteractionEnabled = true;
        return v
    }()
    
    private lazy var backImageView :UIImageView = {
        let v = UIImageView(image: #imageLiteral(resourceName: "shouxiang"))
        v.contentMode = UIView.ContentMode.scaleAspectFill
        return v
    }()
    
    private lazy var iconImage : UIButton = {
        let v = UIButton()
        v.layer.masksToBounds = true;
        v.layer.cornerRadius = 16;
        v.backgroundColor = UIColor.white
        v.setTitle("  View>  ", for: UIControl.State.normal)
        v.setTitleColor(UIColor.black, for: UIControl.State.normal)
        v.titleLabel?.font = preferredFont(size: 14)
        v.isUserInteractionEnabled = false;
        return v
    }()
}
