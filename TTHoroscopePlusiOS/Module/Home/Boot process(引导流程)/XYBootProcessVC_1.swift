//
//  XYBootProcessVC_1.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
//
//输入自己的生日
import UIKit
import SnapKit
//import SVProgressHUD
class XYBootProcessVC_1: TTBaseViewController {
    var selectDate : Date?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        datePicker.showIn(view: view)
        
//        for fontfamilyname in UIFont.familyNames
//        {
//            printLog("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓")
//            printLog("family:\(fontfamilyname)")
//            for fontName in UIFont.fontNames(forFamilyName: fontfamilyname){
//                printLog("font:\(fontName)")
//            }
//            printLog("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑\n\n\n\n\n")
//
//        }
    }
    
    @objc func clickNextBtn(){
        if (selectDate == nil){
//            SVProgressHUD.showInfo(withStatus: "information should not be null!")
//            return
        }
        
        self.navigationController?.pushViewController(XYBootProcessVC_2(), animated: true)
    }
    
    func setupUI(){
//        let backImage = UIImageView.init(frame: view.bounds)
//        backImage.image = #imageLiteral(resourceName: "boot_process1")
//        view.addSubview(backImage)
        view.backgroundColor = UIColor.white
        view.addSubview(nextBtn)
        view.addSubview(tipLabel)
        view.addSubview(tipLabel2)
        view.addSubview(datePicker)
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(83*heightScale)
            make.centerX.equalTo(view)
        }
        
        tipLabel2.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(tipLabel.snp.bottom).offset(96*heightScale)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.width.equalTo(view).multipliedBy(CGFloat(345.0/375.0))
            make.centerX.equalTo(view)
            make.top.equalTo(tipLabel2.snp.bottom)
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

    private lazy var datePicker : LCDatePickerView = {
        let picker = LCDatePickerView.init(completeBlock: { (date) in
            print("选中日期\(date)")
            self.selectDate = date
            XYBootProcessVC_Helper.saveZodiacIndex(date)
        })
        return picker
    }()
    
    private lazy var tipLabel2: UILabel = {
        let label = UILabel(title: "Your birthday ?",
                            fontName: FontName.centuryGothic.rawValue,
                            textSize: 24,
                            color: .black)
        return label
    }()
    
    private lazy var tipLabel: UILabel = {
       let label = UILabel(title: "Welcome to love horoscope \n to interpret your horoscope",
                           fontName: FontName.centuryGothic.rawValue,
                           textSize: 20,
                           color: .black,
                           textAlignment: .left)
        
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

