//
//  XYBootProcessVC_3.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
//选择性别

import UIKit
//import SVProgressHUD
class XYBootProcessVC_3: TTBaseViewController {

    var selectSex : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @objc func clickSexBtn(btn:UIButton){
        selectSex = btn.tag
        let bool = (btn.tag == 1)//1是男性
//        manFlag.isHidden = !bool
//        womanFlag.isHidden = bool
        iConWoMan.isSelected = !bool
        iConMan.isSelected = bool
    }
    
    @objc func clickNextBtn(){
        
        if (selectSex == 0){
            SVProgressHUD.showInfo(withStatus: "information should not be null!")
            return
        }
        self.navigationController?.pushViewController(XYBootProcessVC_4(), animated: true)
    }
    
    func setupUI(){
        view.backgroundColor = UIColor.white
        
        view.addSubview(tipLabel)
        view.addSubview(nextBtn)
        view.addSubview(iConMan)
//        view.addSubview(manFlag)
        view.addSubview(iConWoMan)
//        view.addSubview(womanFlag)
        view.addSubview(iConManLabel)
        view.addSubview(iConWomanLabel)
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(168*heightScale)
            make.centerX.equalTo(view)
        }
        
        iConMan.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(90*heightScale)
            make.left.equalTo(view).offset(55*widthScale)
        }
        iConManLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iConMan)
            make.top.equalTo(iConMan.snp.bottom).offset(12)
        }
//        manFlag.snp.makeConstraints { (make) in
//            make.right.bottom.equalTo(iConMan)
//        }
        iConWoMan.snp.makeConstraints { (make) in
            make.top.equalTo(iConMan)
            make.right.equalTo(view).offset(-55*widthScale)
            make.width.equalTo(iConMan)
        }
        iConWomanLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iConWoMan)
            make.top.equalTo(iConWoMan.snp.bottom).offset(12)
        }
//        womanFlag.snp.makeConstraints { (make) in
//            make.right.bottom.equalTo(iConWoMan)
//        }
        
        
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
//    private lazy var manFlag : UIImageView = {
//        let v = UIImageView(image: #imageLiteral(resourceName: "选中角标"))
//        v.isHidden = true
//        return v
//    }()
//    private lazy var womanFlag : UIImageView = {
//        let v = UIImageView(image: #imageLiteral(resourceName: "选中角标"))
//        v.isHidden = true
//        return v
//    }()
//
    private lazy var iConMan : UIButton = {
        let v = UIButton(imageForState: [#imageLiteral(resourceName: "选中圆"):.selected],
                         backImageForState: [#imageLiteral(resourceName: "单身"):.normal],
                         fontName: FontName.centuryGothic.rawValue,
                         tag: 1)
        v.addTarget(self,
                    action: #selector(clickSexBtn(btn:)),
                    for: .touchUpInside)
        return v
    }()
    private lazy var iConWoMan : UIButton = {
        let v = UIButton(
                         imageForState: [#imageLiteral(resourceName: "选中圆"):.selected],
                         backImageForState: [#imageLiteral(resourceName: "女"):.normal],
                         fontName: FontName.centuryGothic.rawValue,
                         tag: 2)
        v.addTarget(self,
                    action: #selector(clickSexBtn(btn:)),
                    for: .touchUpInside)
        return v
    }()
    
    private lazy var iConManLabel : UILabel = UILabel(title: "Male",
                                                      fontName:FontName.centuryGothic.rawValue,
                                                      textSize: 24,
                                                      color: UIColor.black)
    private lazy var iConWomanLabel : UILabel = UILabel(title: "Female",
                                                        fontName:FontName.centuryGothic.rawValue,
                                                      textSize: 24,
                                                      color: UIColor.black)
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel(title: "Choose your gender ?",
                            fontName:FontName.centuryGothic.rawValue,
                            textSize: 24,
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
