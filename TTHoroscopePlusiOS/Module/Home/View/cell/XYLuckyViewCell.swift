//
//  XYLuckyViewCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/11/1.
//  Copyright © 2018 xykj.inc. All rights reserved.
//

import UIKit
@objcMembers
class XYLuckyViewCell: UITableViewCell {
    var dic:[String: Any] = [:]{
        didSet{
            print(dic)
           if let benefactor = dic["benefactor"] as? [String:Any],
            let index = benefactor["zodiac_index"] as? Int{
             let model = TTManager.sharedInstance()?.localDataManager.zodiacSignModels[index - 1];
                benefactorImage.image = UIImage.init(named: model!.titleImageName)?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay)
                benefactorImage.sizeToFit()
            }
            
            if let benefactor = dic["lucky_number"] as? [String:Any],
                let index = benefactor["number"] as? String{
                numbersImage.text = index
            }
            
            if let benefactor = dic["lucky_color"] as? [String:Any],
                let index = benefactor["color"] as? String{
                let colorHex = String(Int(index) ?? 0,radix:16)
                colorImage.backgroundColor = UIColor.init(hexString: colorHex)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(textA)
        contentView.addSubview(color)
        contentView.addSubview(colorImage)
        
        contentView.addSubview(benefactor)
        contentView.addSubview(benefactorImage)
        
        contentView.addSubview(numbers)
        contentView.addSubview(numbersImage)
        
        
        textA.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(18*widthScale)
            make.left.equalTo(self.contentView).offset(15)
        }
        

        color.snp.makeConstraints { (make) in
            make.top.equalTo(self.textA.snp.bottom).offset(48)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(self.contentView).offset(30*widthScale)
            make.width.equalTo(100*widthScale)
        }
        
        numbers.snp.makeConstraints { (make) in
            make.top.equalTo(self.color)
            make.left.equalTo(self.color.snp.right)
            make.width.equalTo(100*widthScale)
        }

        benefactor.snp.makeConstraints { (make) in
            make.top.equalTo(self.color)
            make.left.equalTo(self.numbers.snp.right)
            make.right.equalTo(self.contentView).offset(-30*widthScale)
            make.width.equalTo(100*widthScale)
        }
        
        colorImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(color)
            make.height.width.equalTo(20)
            make.bottom.equalTo(color.snp.top).offset(-8)
        }
        
        numbersImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(numbers)
            make.height.equalTo(colorImage)
            make.bottom.equalTo(numbers.snp.top).offset(-8)
        }
        
        benefactorImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(benefactor)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.bottom.equalTo(benefactor.snp.top).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- notvip lazy
    private lazy var textA : UILabel = {
        let v = UILabel(title: "Today's Index")
        v.textColor = UIColor.init(hex: 0x333333)
        v.font = preferredFont(size: 15*widthScale)
        return v
    }()
    
    private lazy var color : UILabel = {
        let v = UILabel(title: "Lucky color")
        v.textColor = UIColor.init(hex: 0x333333)
        v.font = customFont(size: 13*widthScale, name: UIFontName.pingfang_sc_regular)
        return v
    }()
    
    private lazy var colorImage : UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 10;
        v.layer.masksToBounds = true;
        v.layer.borderWidth = 1;
        v.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        return v
    }()
    
    private lazy var numbers : UILabel = {
        let v = UILabel(title: "Lucky Numbers")
        v.textColor = UIColor.init(hex: 0x333333)
        v.font = customFont(size: 13*widthScale, name: UIFontName.pingfang_sc_regular)
        return v
    }()
    private lazy var numbersImage : UILabel = {
        let v = UILabel(title: "1")
        v.textColor = UIColor.init(hex: 0x333333)
        v.font = preferredFont(size: 20)
        return v
    }()
    
    private lazy var benefactor : UILabel = {
        let v = UILabel(title: "Benefactor")
        v.textColor = UIColor.init(hex: 0x333333)
        v.font = customFont(size: 13*widthScale, name: UIFontName.pingfang_sc_regular)
        return v
    }()
    
    private lazy var benefactorImage : UIImageView = {
        let v = UIImageView()
        
        return v
    }()
    
    
//
//    private lazy var backImageView :UIImageView = {
//        let v = UIImageView(image: #imageLiteral(resourceName: "shouxiang"))
//        v.contentMode = UIView.ContentMode.scaleAspectFill
//        
//        return v
//    }()
//    private lazy var iconImage : UIButton = {
//        let v = UIButton()
//        v.layer.masksToBounds = true;
//        v.layer.cornerRadius = 18;
//        v.backgroundColor = UIColor.white
//        v.setTitle("  View>  ", for: UIControl.State.normal)
//        v.setTitleColor(UIColor.black, for: UIControl.State.normal)
//        v.titleLabel?.font = preferredFont(size: 16)
//        return v
//    }()
}
