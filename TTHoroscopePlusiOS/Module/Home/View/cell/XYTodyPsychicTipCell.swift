//
//  XYTodyPsychicTipCell.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/9/17.
//  Copyright © 2018年 xykj.inc All rights reserved.
//每日名言Cell//不是vip就展示购买Vip样式

import UIKit

import SnapKit
@objc(XYTodyPsychicTipDelegage)
protocol XYTodyPsychicTipDelegage:NSObjectProtocol {
    func refresPsychicTipCell(cell:XYTodyPsychicTipCell)
}


@objcMembers
class XYTodyPsychicTipCell: UITableViewCell {
    var model : TTTodyPsychicTipModel?{
        didSet{
            guard let nModel = model else {
                return
            }
//            tipTitle.text = nModel.title
            
            tipText.attributedText = self.getAttributedStringWithLineSpace(text: nModel.date + ":" + nModel.content)
            
            TTAdHelpr.getTitleForType(XYShowAdAds.todyPsychicTip) { (type) in
                switch type {
                case XYResultType.notShowBtn:
                    self.changeVip()
                    break;
                default:
                    self.changeNotVip()
                    break
                }
            }
        }
    }
    
    weak var delegate : XYTodyPsychicTipDelegage?
    
    func changeVip(){
        self.isVipUI()
        
        if let url = URL(string: self.model?.img_url ?? "") {
            var isNeedRefresh = false
            SDWebImageManager.shared().diskImageExists(for: url) { (isHave) in
                isNeedRefresh = !isHave
            }
            
            self.tipImage.sd_setImage(with: url,
                                      placeholderImage: #imageLiteral(resourceName: "homeCard_插图"),
                                      options: [],
                                      completed: { (image, error, type, url) in

                        if image == nil{ return }
//                        self.tipImage.snp.remakeConstraints({ (make) in
//                            make.top.equalTo(self.contentView).offset(topMargin)
//                            let scale = image!.size.height / image!.size.width
//                            make.width.equalTo(self.backView)
//                            make.centerX.equalTo(self.contentView)
//                            make.height.equalTo(Int(kWidth * scale))
//                        })
                // 告诉self.view约束需要更新
                self.needsUpdateConstraints()
                // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
                self.updateConstraintsIfNeeded()
                //            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
                //            })
                if (isNeedRefresh){
                    self.delegate?.refresPsychicTipCell(cell: self)
                }
            })
            
            
        }
    }
    
    func changeNotVip(){
        self.notVipUI()
        if let url = URL(string: self.model?.backgroup_url ?? "") {
            self.backImageView.sd_setImage(with: url,
                                           placeholderImage: #imageLiteral(resourceName: "jirizhonggao"),
                                           options: [],
                                           completed: { (image, error, type, url) in
                                            
                                            if image == nil{return}
                                            
//                        self.backImageView.snp.remakeConstraints { (make) in
//                            let scale = image!.size.height / image!.size.width
//                            make.width.equalTo(kWidth)
//                            make.centerX.equalTo(self.contentView)
//                            make.top.equalTo(self.contentView).offset(topMargin)
//                            make.height.equalTo(Int(kWidth * scale))
//                            make.bottom.equalTo(self.contentView).offset(-topMargin)
//                        }
                // 告诉self.view约束需要更新
                self.needsUpdateConstraints()
                // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
                self.updateConstraintsIfNeeded()
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
                                            
            })
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.groupTableViewBackground
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        selectionStyle = .none
        self.notVipUI()

        TTAdHelpr.getTitleForType(XYShowAdAds.todyPsychicTip) { (type) in
            switch type {
            case XYResultType.notShowBtn:
                self.isVipUI()
                break;
            default:
                self.notVipUI()
            }
        }
    }
    
    func isVipUI(){
        backImageView.removeFromSuperview()
        textA.removeFromSuperview()
        iconImage.removeFromSuperview()
        
        contentView.addSubview(backView)
        backView.addSubview(tipImage)
//        contentView.addSubview(tipTitle)
        contentView.addSubview(tipTitleB)
        contentView.addSubview(tipText)
        
//     tipTitle.font = preferredFont(size: 14)
        tipTitleB.font = preferredFont(size: 14)
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(topMargin)
            make.bottom.equalTo(self).offset(-topMargin)
            make.left.equalTo(self).offset(leftMargin)
            make.right.equalTo(self).offset(-leftMargin)
        }
        
        tipImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(topMargin)
            make.width.equalTo(backView)
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(150 * heightScale)
        }
        
//        tipTitle.snp.makeConstraints { (make) in
//            make.left.equalTo(backView).offset(15)
//            make.bottom.equalTo(tipImage).offset(-15)
//        }
        
        tipTitleB.snp.makeConstraints { (make) in
            make.left.equalTo(backView).offset(15)
            make.top.equalTo(tipImage.snp.bottom).offset(15)
        }
        
        tipText.snp.makeConstraints { (make) in
            make.left.equalTo(backView).offset(15)
            make.right.equalTo(backView).offset(-15)
            make.top.equalTo(tipTitleB.snp.bottom).offset(20)
            make.bottom.equalTo(self.contentView).offset(-40)
        }
    }
    
    func notVipUI(){
        backView.removeFromSuperview()
        tipImage.removeFromSuperview()
//        tipTitle.removeFromSuperview()
        tipTitleB.removeFromSuperview()
        tipText.removeFromSuperview()
        
        contentView.addSubview(backImageView)
        contentView.addSubview(textA)
        contentView.addSubview(iconImage)
        
        backImageView.snp.makeConstraints { (make) in

            make.width.equalTo(kWidth)
            make.centerX.equalTo(self.contentView)

            make.top.equalTo(self.contentView).offset(topMargin)
            make.height.equalTo(Int(kWidth * 0.428))

            make.bottom.equalTo(self.contentView).offset(-topMargin)
        }
        
        textA.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-16)
            make.right.equalTo(self).offset(-15)
        }
        
        iconImage.snp.makeConstraints { (make) in
            make.right.equalTo(textA)
            make.top.equalTo(self.textA.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAttributedStringWithLineSpace(text:String)->NSMutableAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left;
            paragraphStyle.lineSpacing = 5; //设置行间距
            paragraphStyle.firstLineHeadIndent = 0;//设置第一行缩进
        let attriDict = [NSAttributedString.Key.paragraphStyle:paragraphStyle,NSAttributedString.Key.kern:0] as [NSAttributedString.Key : Any]
 
            let attributedString = NSMutableAttributedString(string: text, attributes: attriDict)
        return attributedString
    }
    
//    - (NSMutableAttributedString *)getAttributedStringWithLineSpace:(NSString *) text lineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
//    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
//    //调整行间距
//    paragraphStyle.lineSpacing= lineSpace;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.lineSpacing = lineSpace; //设置行间距
//    paragraphStyle.firstLineHeadIndent = 0;//设置第一行缩进
//    NSDictionary*attriDict =@{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
//    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attriDict];
//
//    return attributedString;
//    }

    
   //MARK:-  isvip lazy
    private lazy var tipImage : UIImageView = {
        let v = UIImageView(image: #imageLiteral(resourceName: "homeCard_插图"))
        v.contentMode = UIView.ContentMode.scaleAspectFill
        v.layer.masksToBounds = true
        
        return v
    }()
//    private lazy var tipTitle = UILabel(title: "Today`s Psychic Tip",color: .black)
    private lazy var tipTitleB = UILabel(title: "Passion Pull",color: .black)
    private lazy var tipText = UILabel(title: "--",fontName:UIFontName.pingfang_sc_light.rawValue, textSize:14,color: .black, textAlignment: .left)
    
    private lazy var backView :UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
//        v.layer.masksToBounds = true
//        v.layer.cornerRadius = 5
        return v
    }()
    
    //MARK:- notvip lazy
    private lazy var textA : UILabel = {
        let v = UILabel(title: "Tody`s Psychic Tip")
        v.font = preferredFont(size: 19)
        return v
    }()
    
    private lazy var backImageView :UIImageView = {
        let v = UIImageView(image: #imageLiteral(resourceName: "jirizhonggao"))
//        v.contentMode = UIViewContentMode.init(rawValue: 1)!
//        v.layer.masksToBounds = true
//        v.layer.cornerRadius = 5
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
//    private lazy var iconImage = UIImageView(image: #imageLiteral(resourceName: "psychic_icon"))
}
