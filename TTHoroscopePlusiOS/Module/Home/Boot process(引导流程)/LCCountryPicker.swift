//
//  LCCountryPicker.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/23.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

import Foundation
import SwiftyJSON
enum SelectType:String {
    case country
    case regin
}

class LCCountryPicker:UIView{
    typealias callBack = (_ selectRow:[String:String])->()
    
    func showIn(view:UIView){
        view.addSubview(self)
    }

    
    
    @objc func clickCancelOrConfirm(btn:UIButton){
        if btn.tag == 1{
            if scrollToSource.isEmpty,
                sourceArray.count > 0{
                scrollToSource = sourceArray[0].dictionaryObject! as! [String : String]
            }
            
            selectBlock?(scrollToSource)
        }
        self.removeFromSuperview()
    }
    
    fileprivate var type : SelectType = .country
    /**
     默认滚动到当前时间
     */
    convenience init(type:SelectType,scrollToSource:[String:String] = [:],completeBlock:@escaping callBack){
        self.init()
        if type == .regin && scrollToSource.isEmpty{
            printLog("字典不可为空")
            return
        }
        self.type = type
        self.scrollToSource = scrollToSource
        selectBlock = completeBlock
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.layoutIfNeeded()
        
        addSubview(backBtn)
        addSubview(datePickerBack)
        addSubview(datePicker)
        addSubview(line)
        addSubview(Cancel)
        addSubview(Confirm)
        
        backBtn.snp.makeConstraints { (make) in
            make.top.width.equalTo(self)
            make.bottom.equalTo(datePickerBack.snp.bottom)
        }
        
        Cancel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.bottom.equalTo(line.snp.top)
        }
        
        Confirm.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(Cancel)
        }
        
        line.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.bottom.equalTo(datePicker.snp.top)
        }
        
        datePicker.snp.makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.9)
            make.centerX.equalTo(self)
            make.height.equalTo(216-50)
            make.bottom.equalTo(self)
        }
        
        let effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let effectView = UIVisualEffectView(effect: effect)
        datePickerBack.addSubview(effectView)

        effectView.snp.makeConstraints { (make) in
            make.edges.equalTo(datePickerBack)
        }
        
        datePickerBack.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(216)
        }
        
        
        defaultConfig()
    }
    
    
    func defaultConfig() {
        var jsonData: Data?
        if let file = Bundle.main.path(forResource: "db_en", ofType: "json") {
            jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
        } else {
            print("Fail")
        }
    
        guard let swiftJson = try? JSON(data: jsonData!) else{
            printLog("不行，没成功")
            return
        }
        
        if type == .country{
            let country = swiftJson.dictionary!["country"]
            sourceArray = country!.arrayValue
        }else if type == .regin{
            let c = scrollToSource["Code"]!
            
             let state = swiftJson.dictionary!["state"]![c]
            let city = swiftJson.dictionary!["city"]![c]
            
            if (state.array != nil){
                sourceArray = state.arrayValue
                printLog("state 应该是省级别\(state.arrayValue)")
            }else if city.array != nil{
                printLog("city 应该是城市级别\(city.arrayValue)")
                sourceArray = city.arrayValue
            }else{
                printLog("都为空，没找到")
            }
        }
        
        
//        printLog(country)

        
        
        //设置数据
//        if let index = sourceArray.index(of: scrollToSource){
//            getNowRow(row: index, animated: true)
//        }
    }
    
    deinit {
        printLog("我已释放")
    }
    
    //MARK:- lazy
    /**
     *  滚轮日期颜色(默认黑色)
     */
    var datePickerColor = UIColor.white
    
    //日期存储数组
    fileprivate var sourceArray =  [JSON]()
    
    //记录位置
    fileprivate var sourceIndex = 0
    
    fileprivate lazy var Confirm : UIButton = {
        let cancel = UIButton(titleForState: ["Confirm":.normal],
                              fontName: FontName.centuryGothic.rawValue,
                              tag: 1)
        cancel.addTarget(self, action: #selector(clickCancelOrConfirm(btn:)), for: UIControl.Event.touchUpInside)
        return cancel
    }()
    
    fileprivate lazy var Cancel : UIButton = {
        let cancel = UIButton(titleForState: ["Cancel":.normal],
                              fontName: FontName.centuryGothic.rawValue,
                              tag: 2)
        cancel.addTarget(self, action: #selector(clickCancelOrConfirm(btn:)), for: UIControl.Event.touchUpInside)
        return cancel
    }()
    
    fileprivate lazy var datePicker : UIPickerView = {
        let v = UIPickerView()
        v.showsSelectionIndicator = true
        v.delegate = self
        v.dataSource = self
        return v
    }()
    fileprivate lazy var backBtn : UIButton = {
        let v = UIButton(fontName: FontName.centuryGothic.rawValue,
                         tag:3)
        v.addTarget(self, action: #selector(clickCancelOrConfirm(btn:)), for: UIControl.Event.touchUpInside)
        return v
    }()
    fileprivate lazy var datePickerBack : UIView = {
        let v = UIView()
        
        v.backgroundColor = UIColor.black
        v.alpha = 0.9
        return v
    }()
    
    fileprivate lazy var line : UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    fileprivate var scrollToSource = [String:String]()
    fileprivate var selectBlock : callBack?
}

extension LCCountryPicker:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sourceArray.count
    }
    
}

extension LCCountryPicker:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        
        //设置分割线的颜色
        for singleLine in pickerView.subviews{
            if (singleLine.frame.size.height < 1){
                singleLine.backgroundColor = UIColor.white
                singleLine.alpha = 0.3
            }
        }
        
        let customLabel = UILabel.init(fontName:FontName.centuryGothic.rawValue,
                                       textSize: 21, textAlignment: .center)
        let title = "\(sourceArray[row].dictionaryValue["Name"]!.stringValue)"

        customLabel.text = title
        customLabel.textColor = datePickerColor
        return customLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        sourceIndex = row
    
        pickerView.reloadAllComponents()
        
        if (sourceArray.count > 0 && sourceArray[row].dictionaryObject != nil){
            scrollToSource = sourceArray[row].dictionaryObject! as! [String : String]
        }
        //选中回调放到确定中
    }
    

    
    //滚动到指定的时间位置
    func getNowRow(row:Int,animated:Bool){
    
        datePicker.reloadAllComponents()
        datePicker.selectRow(row, inComponent: 0, animated: animated)
    }
}

