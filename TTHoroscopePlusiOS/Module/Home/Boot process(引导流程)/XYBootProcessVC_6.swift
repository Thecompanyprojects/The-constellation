//
//  XYBootProcessVC_6.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
//选择伴侣生日

import UIKit
//import SVProgressHUD

class XYBootProcessVC_6: TTBaseViewController {
    var selectDate : Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        datePicker.showIn(view: view)
    }
    @objc func clickNextBtn(){
        if (selectDate == nil){
//            SVProgressHUD.showInfo(withStatus: "information should not be null!")
//            return
        }
        self.navigationController?.pushViewController(XYBootProcessVC_7(), animated: true)
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        
        
        view.addSubview(nextBtn)
        view.addSubview(tipLabel)
        view.addSubview(datePicker)
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(168*heightScale)
            make.centerX.equalTo(view)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-70*heightScale)
            make.width.equalTo(200*widthScale)
            make.height.equalTo(50*heightScale)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.width.equalTo(view).multipliedBy(CGFloat(345.0/375.0))
            make.centerX.equalTo(view)
            make.top.equalTo(tipLabel.snp.bottom).offset(80)
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
        })
        return picker
    }()
    
    private lazy var tipLabel: UILabel = {

        let label = UILabel(title: "Your pelationship's birthday ?",
                            fontName:FontName.centuryGothic.rawValue,
                            textSize: 24 * widthScale,
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
