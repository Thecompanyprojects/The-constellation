//
//  LCDatePickerView.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/22.
//  Copyright © 2018年 xykj.inc All rights reserved.
//
//import YYKit
import Foundation
let MAXYEAR = 2099
let MINYEAR = 1900

class LCDatePickerView:UIView{
    typealias callBack = (_ date:Date)->()
    
    func showIn(view:UIView){
        view.addSubview(self)
    }
    /**
     默认滚动到当前时间
     */
    convenience init(completeBlock:@escaping callBack){
        self.init()
        selectBlock = completeBlock
        self.frame = CGRect.init(x: 0, y: 0, width: 300, height: 280)
        self.layoutIfNeeded()
        
        addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
            make.top.left.equalTo(self)
        }
        
        defaultConfig()
    }
    
    
    func defaultConfig() {

    //循环滚动时需要用到
        preRow = (self.scrollToDate.dateYear() - MINYEAR) * 12+self.scrollToDate.dateMonth() - 1
    
    //设置年月日时分数据

        for i in 0..<60 {
            if (0<i && i<=12){ monthArray.append(i)}
            if (i<24){hourArray.append(i)}
            minuteArray.append(i)
        }
        let date_current = Date()
            for i in MINYEAR...date_current.dateYear(){
                yearArray.append(i)
            }
//
        getNowDate(date: scrollToDate, animated: true)
    }
    
    
    
    //MARK:- lazy
/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
    fileprivate var maxLimitDate = NSDate("2099-12-31 23:59", withFormat: "yyyy-MM-dd HH:mm") as Date
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
    fileprivate var minLimitDate = NSDate("1900-01-01 00:00", withFormat: "yyyy-MM-dd HH:mm") as Date
    /**
     *  滚轮日期颜色(默认黑色)
     */
    var datePickerColor = UIColor.black


    //日期存储数组
    fileprivate var yearArray = [Int]()
    fileprivate var monthArray = [Int]()
    fileprivate var dayArray = [Int]()
    fileprivate var hourArray = [Int]()
    fileprivate var minuteArray = [Int]()
    //记录位置
    fileprivate var yearIndex = 0
    fileprivate var monthIndex = 0
    fileprivate var dayIndex = 0
    
    fileprivate var preRow = 0
    
    fileprivate var startDate = Date()

    fileprivate lazy var datePicker : UIPickerView = {
       let v = UIPickerView()
        v.showsSelectionIndicator = true
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    fileprivate var scrollToDate = Date()
    fileprivate var selectBlock : callBack?
    fileprivate let dateFormatter = "yyyy-MM-dd"
}

extension LCDatePickerView:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberArr = getNumberOfRowsInComponent()
        return numberArr[component]
    }
    
    
    func getNumberOfRowsInComponent()->[Int] {
        let yearNum = yearArray.count
        let monthNum = monthArray.count
        let dayNum = daysfromYear(yearArray[yearIndex], month: monthArray[monthIndex])
        
//        let hourNum = hourArray.count
//        let minuteNum = minuteArray.count
//        let date_current = Date()
//        let timeInterval = date_current.dateYear() - MINYEAR;
//
        return [monthNum,dayNum,yearNum]
    }
    
}

extension LCDatePickerView:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{

        //设置分割线的颜色
        for singleLine in pickerView.subviews{
            if (singleLine.frame.size.height < 1){
                singleLine.backgroundColor = UIColor.black
            }
        }
        
        
        let customLabel = UILabel(fontName:FontName.centuryGothic.rawValue,
                                       textSize: 21,
                                       textAlignment: .center)
        var title = ""
            if (component==2) {
                title = "\(yearArray[row])"
            }
            if (component==0) {
                title = TTBaseTools.monthName(withIndex_en: monthArray[row])
            }
            if (component==1) {
                title = "\(dayArray[row])"
            }
        
        customLabel.text = title
        customLabel.textColor = datePickerColor
        return customLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (component == 0) {
            monthIndex = row
        }
        if (component == 1) {
            dayIndex = row
        }
        if (component == 2) {
            yearIndex = row
        }
        if (component == 0 || component == 2){
            _=daysfromYear(yearArray[yearIndex], month: monthArray[monthIndex])
            if (dayArray.count-1<dayIndex) {
                dayIndex = dayArray.count-1
            }
        }
        
        pickerView.reloadAllComponents()
        
        let dateStr = "\(yearArray[yearIndex])-\(monthArray[monthIndex])-\(dayArray[dayIndex])"
    
        
        self.scrollToDate = dateStr.dateFromTimeStr()
            
//            NSDate(dateStr, withFormat: "yyyy-MM-dd") as Date
        if scrollToDate.compare(minLimitDate) == .orderedAscending{
            self.scrollToDate = self.minLimitDate
            getNowDate(date: minLimitDate, animated: true)
        }else if (scrollToDate.compare(maxLimitDate) == .orderedDescending){
            self.scrollToDate = self.maxLimitDate;
            self.getNowDate(date: maxLimitDate, animated: true)
        }
        
        startDate = self.scrollToDate
        //选中回调
        selectBlock?(scrollToDate)
        print("选中了\(dateStr)")
    }
    
    
    //通过年月求每月天数
    func daysfromYear(_ year:Int,month:Int)->Int {
      let days = (NSDate("\(year)-\(month)", withFormat: "yyyy-MM") as Date).totalDaysInMonth()
            dayArray.removeAll()
        for i in 1...days{
            dayArray.append(i)
        }
        return days
    }
    
    //滚动到指定的时间位置
    func getNowDate(date:Date, animated:Bool){
        _=daysfromYear(date.dateYear(), month: date.dateMonth())

        yearIndex = date.dateYear()-MINYEAR
        monthIndex = date.dateMonth() - 1
        dayIndex = date.dateDay() - 1
        
        //循环滚动时需要用到
        preRow = (self.scrollToDate.dateYear()-MINYEAR)*12+self.scrollToDate.dateMonth()-1
        
        let indexArray = [monthIndex,dayIndex,yearIndex]
        //    self.showYearView.text = _yearArray[yearIndex];
        datePicker.reloadAllComponents()
        
        for i in 0..<indexArray.count {
            datePicker.selectRow(indexArray[i], inComponent: i, animated: animated)
        }
    }
}


/// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()
/// 当前日历对象
private let calendar = Calendar.current
extension String{
    /// 年月日转换为date;
    ///
    /// - Parameter timeStr: <#timeStr description#>
    /// - Returns: <#return value description#>
    func dateFromTimeStr()->Date{
        
        // 设置日期格式(为了转换成功)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd";
        // NSString * -> NSDate *
        let date = dateFormatter.date(from: self)!
        return date
    }
}
