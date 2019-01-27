//
//  XYBootProcessVC_2.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/21.
//  Copyright © 2018年 xykj.inc All rights reserved.
//输入姓名

import UIKit
//import SVProgressHUD

class XYBootProcessVC_2: TTBaseViewController {
    var name : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @objc func clickNextBtn(){
        if (name == nil || name!.isEmpty){
            
            SVProgressHUD.showInfo(withStatus: "information should not be null!")
            return
        }
        
        self.navigationController?.pushViewController(XYBootProcessVC_3(), animated: true)
    }
    
    @objc func clickTextFileBigBtn(){
        textFile.becomeFirstResponder()
    }
    func setupUI(){
//        let backImage = UIImageView.init(frame: view.bounds)
//        backImage.image = #imageLiteral(resourceName: "boot_process2")
//        view.addSubview(backImage)
        view.backgroundColor = UIColor.white
        view.addSubview(nextBtn)
        view.addSubview(tipLabel)
        view.addSubview(textFile)
        view.addSubview(textFileLine)
        view.addSubview(textFileBigBtn)
        
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(170*heightScale)
            make.centerX.equalTo(view)
        }
        
        textFile.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(168*heightScale)
            make.centerX.equalTo(view)
            make.width.equalTo(250*widthScale)
        }
        
        textFileLine.snp.makeConstraints { (make) in
            make.width.equalTo(250*widthScale)
            make.top.equalTo(textFile.snp.bottom).offset(1)
            make.centerX.equalTo(view)
            make.height.equalTo(1)
        }
        
        textFileBigBtn.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.bottom.equalTo(textFileLine)
            make.width.equalTo(view)
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
    @objc func inPutName(textFile:UITextField){
        if textFile.text == nil{
            name = ""
            return
        }
        
        name = textFile.text
        printLog("输入字符:\(textFile.text!)")
    }
    private lazy var textFileBigBtn : UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickTextFileBigBtn), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    private lazy var textFile : UITextField = {
        let file = UITextField()
        file.tintColor = UIColor.black
        file.textColor = UIColor.black
        
        file.addTarget(self, action: #selector(inPutName(textFile:)), for: UIControl.Event.editingChanged)
        file.textAlignment = .center
        return file
    }()
    
    private lazy var textFileLine : UIView = {
       let line = UIView()
        line.alpha = 0.6
        line.backgroundColor = UIColor.black
        return line
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel(title: "Your name ?",
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
