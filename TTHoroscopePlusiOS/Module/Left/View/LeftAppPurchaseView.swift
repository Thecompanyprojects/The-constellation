//
//  LeftAppPurchaseView.swift
//  XToolWhiteNoiseIOS
//
//  Created by 郭连城 on 2018/9/14.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

import UIKit

@objcMembers
class LeftAppPurchaseView: UIView {
    
    typealias clickBack = ()->()
    
    var clickPayBtn : clickBack?
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subTitleA: UILabel!

    @IBOutlet weak var payBtn: UIButton!
    
    @IBAction func clickPayBtn(_ sender: UIButton) {
        clickPayBtn?()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        widthConstraint.constant = (100*widthScale)
    }
    
    // MARK: - 实例化方法
   @objc class func appPurchaseView() -> LeftAppPurchaseView {
        
        let nib = UINib(nibName: "LeftAppPurchaseView", bundle: nil)
        // 从 XIB 加载完成视图，就会调用 awakeFromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! LeftAppPurchaseView
        // XIB 加载默认 600 * 600
//        v.frame = UIScreen.main().bounds
//        v.setupUI()
        return v
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        layer.masksToBounds = true
        iconImage.sizeToFit()
        self.backgroundColor = UIColor(white: 0, alpha: 1).withAlphaComponent(0)
        
        title.textColor = UIColor(white: 0, alpha: 1)
        subTitleA.textColor = UIColor(white: 0, alpha: 1)
//        payBtn.layer.cornerRadius = 5
//        payBtn.layer.masksToBounds = true

    }
    
    
    func setConfigDic(dict:[String:Any]){
        guard let payDic = dict["subscribe"] as? [String:Any] else{
            return
        }
        
        
        var title_str = payDic["title"] as? String ?? "Detailed future prediction.\nDaily Premium contents.\nAds-free experience."
        
        let titleArr =  title_str.components(separatedBy: "\n")
        
        let strM = NSMutableAttributedString()


        for i in 0 ..< titleArr.count{
            let str = titleArr[i]
            let attchment = NSTextAttachment()
        
            attchment.image = UIImage.init(named: "duihao")
            attchment.bounds = CGRect.init(x: 0, y: 0, width: 10, height: 10)
            
            let imageStr = NSAttributedString(attachment: attchment)

            strM.append(imageStr)
            strM.yy_appendString("  ")
            strM.yy_appendString(str)

            if (i < titleArr.count - 1) {
                strM.yy_appendString("\n")
            }
        }
        
        strM.yy_lineSpacing = 5
//        strM.yy_paragraphSpacing = 10
        
//        if let titleColorStr = dict["title_color"] as? String{
//            title.textColor = UIColor(hexString: titleColorStr).withAlphaComponent(1)
//        }
//        if let subColorStr = dict["sub_title_color"] as? String{
//            subTitleA.textColor = UIColor(hexString: subColorStr)
//            subTitleB.textColor = UIColor(hexString: subColorStr)
//            subTitleC.textColor = UIColor(hexString: subColorStr)
//        }
        
//        if let text = payDic["title"] as? String{
//            title.text = text
//        }
        
//        if  let sub_title1 = payDic["sub_title1"] as? String,
//            let sub_title2 = payDic["sub_title2"] as? String,
//            let sub_title3 = payDic["sub_title3"] as? String{
//
//            subTitleA.text = sub_title1
//            subTitleB.text = sub_title2
//            subTitleC.text = sub_title3
//        }
        
        
        if let leftVc = dict["leftVc"] as? [String:Any],
           let text = leftVc["leftVC_paybtn_text"] as? String{
            payBtn.setTitle(text, for: UIControl.State.normal)
            
            if let textFont = leftVc["leftVC_paybtn_fontSize"] as? Int{
                payBtn.titleLabel?.font = preferredFont(size: CGFloat(textFont) * heightScale)
            }
        }
        subTitleA.numberOfLines = 0;
        subTitleA.attributedText = strM
        
        title.sizeToFit()
        subTitleA.sizeToFit()
   
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
