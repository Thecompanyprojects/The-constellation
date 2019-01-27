//
//  XYBootProcessVC_4.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
//选择血型

import UIKit
//import SVProgressHUD
class XYBootProcessVC_4: TTBaseViewController {

    
    var selectBloodType : Int = 0 //0是没选择
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    @objc func clickBloodType(btn:UIButton){
        btn.isSelected = true
        selectBloodType = btn.tag
        
        switch btn.tag {
        case 1:
            B.isSelected = false
            O.isSelected = false
            AB.isSelected = false
            
   
            break
        case 2:
            A.isSelected = false
            O.isSelected = false
            AB.isSelected = false
            
        
            break
        case 3:
            A.isSelected = false
            B.isSelected = false
            AB.isSelected = false
            
       
            break
        case 4:
            A.isSelected = false
            B.isSelected = false
            O.isSelected = false
        
            break
        default:break
        }
    }
    @objc func clickNextBtn(){
        if (selectBloodType == 0){
            SVProgressHUD.showInfo(withStatus: "information should not be null!")
            return
        }
        self.navigationController?.pushViewController(XYBootProcessVC_5(), animated: true)
    }
    
    func setupUI(){
       view.backgroundColor = UIColor.white
        
        view.addSubview(tip)
        
        
        view.addSubview(A)
        view.addSubview(B)
        view.addSubview(O)
        view.addSubview(AB)
        
   
        view.addSubview(nextBtn)
        tip.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(168*heightScale)
        }
        
        A.snp.makeConstraints { (make) in
            make.top.equalTo(tip.snp.bottom).offset(90*heightScale)
            make.left.equalTo(view).offset(60)
            make.right.equalTo(B.snp.left).offset(-60)
            make.height.equalTo(A.snp.width)
        }
        
        B.snp.makeConstraints { (make) in
            make.top.equalTo(A)
            make.right.equalTo(view).offset(-60)
            make.width.height.equalTo(A)
        }
        
        O.snp.makeConstraints { (make) in
            make.top.equalTo(A.snp.bottom).offset(40)
            make.left.equalTo(A)
            make.width.height.equalTo(A)
        }
        AB.snp.makeConstraints { (make) in
            make.right.equalTo(B)
            make.top.equalTo(O)
            make.width.height.equalTo(O)
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
    
    private lazy var tip : UILabel = {
       let tip = UILabel(title: "You blood type ?",
                         fontName:FontName.centuryGothic.rawValue,
                         textSize: 24,
                         color: UIColor.black)
        return tip
    }()
    

    private lazy var A : UIButton = {
        let v = UIButton(imageForState: [#imageLiteral(resourceName: "选中圆"):.selected],
                         backImageForState: [#imageLiteral(resourceName: "blood_type_a"):.normal],
                         fontName: FontName.centuryGothic.rawValue,
                         tag: 1)
        v.setBackgroundImage(UIImage(named: "blood_type_a")?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay), for: UIControl.State.normal)
        v.addTarget(self, action: #selector(clickBloodType(btn:)), for: UIControl.Event.touchUpInside)
        return v
    }()
    
  
    private lazy var B : UIButton = {
        let v = UIButton(imageForState: [#imageLiteral(resourceName: "选中圆"):.selected],
                         backImageForState: [#imageLiteral(resourceName: "blood_type_b"):.normal],
                         fontName: FontName.centuryGothic.rawValue,
                         tag: 2)
                v.setBackgroundImage(UIImage(named: "blood_type_b")?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay), for: UIControl.State.normal)
        v.addTarget(self, action: #selector(clickBloodType(btn:)), for: UIControl.Event.touchUpInside)
        return v
    }()
    
    private lazy var O : UIButton = {
        let v = UIButton(imageForState: [#imageLiteral(resourceName: "选中圆"):.selected],
                         backImageForState: [#imageLiteral(resourceName: "blood_type_O"):.normal],
                         fontName: FontName.centuryGothic.rawValue,
                         tag: 3)
                v.setBackgroundImage(UIImage(named: "blood_type_O")?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay), for: UIControl.State.normal)
        v.addTarget(self, action: #selector(clickBloodType(btn:)), for: UIControl.Event.touchUpInside)
        return v
    }()
    
    
    
    private lazy var AB : UIButton = {
        let v = UIButton(imageForState: [#imageLiteral(resourceName: "选中圆"):.selected],
                         backImageForState: [#imageLiteral(resourceName: "blood_type_AB"):.normal],
                         fontName: FontName.centuryGothic.rawValue,
                         tag: 4)
                v.setBackgroundImage(UIImage(named: "blood_type_AB")?.withTintColor(UIColor.black, blendMode: CGBlendMode.overlay), for: UIControl.State.normal)
        v.addTarget(self, action: #selector(clickBloodType(btn:)), for: UIControl.Event.touchUpInside)
        return v
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
