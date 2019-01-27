//
//  XYBootProcessVC_7.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
// 选择出生地址

import UIKit
//import SVProgressHUD
class XYBootProcessVC_7: TTBaseViewController {
    
    var selectCountry : Int = 0//0是没有选
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
        //        let jsonString = String(data: jsonData!, encoding: .utf8)
        //        printLog(jsonObject)
        //        printLog(jsonString)
        // Do any additional setup after loading the view.
    }
    fileprivate var selectDic = [String:String]()
    @objc func clickCountryBtn(btn:UIButton){
        if btn.tag == 1{
            let picker = LCCountryPicker.init(type: SelectType.country) { (dic) in
                printLog("选中了国家\(dic)")
                self.selectCountry = btn.tag
                self.selectDic = dic
//                if (self.countryText.titleLabel?.text != dic["Name"]){
//                    self.regionText.titleLabel?.text = ""
//                }
                self.countryText.setTitle(dic["Name"], for: UIControl.State.normal)
            }
            picker.showIn(view: view)
        }else if btn.tag == 2{
            let picker = LCCountryPicker.init(type: SelectType.regin, scrollToSource: selectDic) { (dic) in
                printLog("选中了城市\(dic)")
                self.regionText.setTitle(dic["Name"], for: UIControl.State.normal)
            }
            picker.showIn(view: view)
        }
    }
    
    
    @objc func clickNextBtn(){
        if (selectCountry == 0){
            SVProgressHUD.showInfo(withStatus: "information should not be null!")
            return
        }
        
        let vc = TTVipPaymentController.init()
        
        //            vc.scrollViewHeight =  UIScreen.main.bounds.height - (UIDevice().isX() ? 88 : 64)
        vc.isFullScreen = true
        vc.isBootProcess = true
        navigationController?.pushViewController(vc, animated: true)
        XYBootProcessVC_Helper.paySourceBoot()

    }
    
    
    
    
    func setupUI(){
        
        view.backgroundColor = UIColor.white
        regionT.textColor = .black
        countryT.textColor = .black
        view.addSubview(tipLabel)
        view.addSubview(nextBtn)
        view.addSubview(countryT)
        view.addSubview(countryLine)
        view.addSubview(countryText)
        view.addSubview(regionT)
        view.addSubview(regionLine)
        view.addSubview(regionText)
        
        view.addSubview(arrow)
        view.addSubview(arrow1)
        
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(168*heightScale)
            make.centerX.equalTo(view)
        }
        
        countryT.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(105*heightScale)
            make.left.equalTo(countryLine)
        }
        countryText.snp.makeConstraints { (make) in
            make.centerY.equalTo(countryT)
            make.left.equalTo(countryT)
            make.width.equalTo(countryLine.snp.width)
        }
        
        arrow.snp.makeConstraints { (make) in
            make.right.equalTo(countryLine)
            make.centerY.equalTo(countryT)
        }
        
        countryLine.snp.makeConstraints { (make) in
            make.width.equalTo(300*widthScale)
            make.centerX.equalTo(view)
            make.top.equalTo(countryT.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        
        regionT.snp.makeConstraints { (make) in
            make.top.equalTo(countryLine.snp.bottom).offset(45*heightScale)
            make.left.equalTo(regionLine)
        }
        
        regionText.snp.makeConstraints { (make) in
            make.centerY.equalTo(regionT)
            make.left.equalTo(regionT)
            make.width.equalTo(regionLine.snp.width)
        }
        
        arrow1.snp.makeConstraints { (make) in
            make.right.equalTo(regionLine)
            make.centerY.equalTo(regionT)
        }
        
        regionLine.snp.makeConstraints { (make) in
            make.width.equalTo(300*widthScale)
            make.centerX.equalTo(view)
            make.height.equalTo(1)
            make.top.equalTo(regionT.snp.bottom).offset(8)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-70*heightScale)
            make.width.equalTo(200*widthScale)
            make.height.equalTo(50*heightScale)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    private lazy var datePicker : LCCountryPicker = {
    //
    //        return picker
    //    }()
    //
    private lazy var arrow = UIImageView(image: #imageLiteral(resourceName: "选择展开"))
    private lazy var arrow1 = UIImageView(image: #imageLiteral(resourceName: "选择展开"))
    private lazy var countryT : UILabel = UILabel(title: "Country",     fontName:FontName.centuryGothic.rawValue,
                                                  textSize: 18,
                                                  textAlignment: .left)
    
    private lazy var countryLine : UIView = {
        let line = UIView()
        line.alpha = 0.6
        line.backgroundColor = UIColor.black
        return line
    }()
    
    private lazy var countryText : UIButton = {
        let v = UIButton(fontName: FontName.centuryGothic.rawValue,
                         tag:1)
        v.addTarget(self, action: #selector(clickCountryBtn(btn:)), for: UIControl.Event.touchUpInside)
        v.setTitleColor(UIColor.black, for: UIControl.State.normal)
        v.sizeToFit()
        return v
    }()
    
    private lazy var regionText : UIButton = {
        let v = UIButton(fontName: FontName.centuryGothic.rawValue,tag:2)
        v.sizeToFit()
        v.setTitleColor(UIColor.black, for: UIControl.State.normal)
        v.addTarget(self, action: #selector(clickCountryBtn(btn:)), for: UIControl.Event.touchUpInside)
        return v
    }()
    
    private lazy var regionT : UILabel = UILabel(title: "region",
                                                 fontName:FontName.centuryGothic.rawValue,
                                                 textSize: 18,
                                                 textAlignment: .left)
    
    private lazy var regionLine : UIView = {
        let line = UIView()
        line.alpha = 0.6
        line.backgroundColor = UIColor.black
        return line
    }()
    
    
    
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel(title: "The address nof your birth ?",
                            fontName:FontName.centuryGothic.rawValue,
                            textSize:24,
                            color: UIColor.black)
        return label
    }()
    private lazy var nextBtn : UIButton = {
        let btn = UIButton(titleForState: ["Next": .normal],
                           fontName: FontName.centuryGothic.rawValue)
        btn.addTarget(self, action: #selector(clickNextBtn), for: UIControl.Event.touchUpInside)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.setTitleColor(.black, for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage(color: UIColor(hex: 0xcccccc)), for: UIControl.State.normal)
        return btn
    }()
}

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
