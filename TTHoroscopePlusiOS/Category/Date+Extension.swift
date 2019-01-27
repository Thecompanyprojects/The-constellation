//
//  Date+Extension.swift
//  Horoscope
//
//  Created by 郭连城 on 2018/8/22.
//  Copyright © 2018年 xykj.inc All rights reserved.
//

/// 日期格式化器 - 不要频繁的释放和创建，会影响性能
private let dateFormatter = DateFormatter()
/// 当前日历对象
private let calendar = Calendar.current

extension  Date{
    
    
    /// 获得当前 NSDate 对象对应的日子
    ///
    /// - Returns: <#return value description#>
    func dateDay()->Int {
        let components = calendar.component(Calendar.Component.day, from: self)
        return components
    }
    
    ///  获得当前 NSDate 对象对应的月份
    ///
    /// - Returns: <#return value description#>
    func dateMonth()->Int {
        let components = calendar.component(Calendar.Component.month, from: self)
        return components
    }
    
    /// 获得当前 NSDate 对象对应的年份
    ///
    /// - Returns: <#return value description#>
    func dateYear()->Int {
        let components = calendar.component(Calendar.Component.year, from: self)
        return components
    }
    
    /// 获得当前 NSDate 对象的上个月的某一天（此处定为15号）的 NSDate 对象
    ///
    /// - Returns: <#return value description#>
    func previousMonthDate()->Date {
        let set : Set<Calendar.Component> = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day]
        var components = calendar.dateComponents(set, from: self)
        
        components.day = 15 // 定位到当月中间日子
        if (components.month == 1) {
            components.month = 12
            components.year = components.year! - 1
        } else {
            components.month = components.month! - 1
        }
        
        let previousDate = calendar.date(from: components)
        return previousDate!
    }
    
    /// 获得当前 NSDate 对象的下个月的某一天（此处定为15号）的 NSDate 对象
    ///
    /// - Returns: <#return value description#>
    func nextMonthDate()->Date {
        let set : Set<Calendar.Component> = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day]
        var components = calendar.dateComponents(set, from: self)
        
        components.day = 15 // 定位到当月中间日子
        
        if (components.month == 12) {
            components.month = 1
            components.year! += 1
        } else {
            components.month! += 1
        }
        let nextDate = calendar.date(from: components)
        return nextDate!
    }
    
    /// 获得当前 NSDate 对象对应的月份的总天数
    ///
    /// - Returns: <#return value description#>
    func totalDaysInMonth()->Int {
        
        let totalDays = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!.count
        return totalDays
    }
    
    /// 获得当前 NSDate 对象对应月份当月第一天的所属星期
    ///
    /// - Returns: <#return value description#>
    func firstWeekDayInMonth()->Int {
        let set : Set<Calendar.Component> = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day]
        
        var components = calendar.dateComponents(set, from: self)
        
        components.day = 1; // 定位到当月第一天
        let firstDay = calendar.date(from: components)
        // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
        let firstWeekDay = calendar.ordinality(of: Calendar.Component.day, in: Calendar.Component.month, for: firstDay!)! - 1
        
        return firstWeekDay
    }
    
    
    /**
     2  * @method
     3  *
     4  * @brief 获取两个日期之间的天数
     5  * @param fromDate       起始日期
     6  * @param toDate         终止日期
     7  * @return    总天数
     8  */
    
    //    func numberOfDaysWithFromDate(fromDate:Date,toDate:Date)->Int{
    //        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    //
    //        let comp = calendar.dateComponents(<#T##components: Set<Calendar.Component>##Set<Calendar.Component>#>, from: <#T##Date#>, to: <#T##Date#>)
    //
    //
    //             NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
    //                                                          fromDate:fromDate
    //                                                            toDate:toDate
    //                                                           options:NSCalendarWrapComponents];
    //             NSLog(@" -- >>  comp : %@  << --",comp);
    //             return comp.day;
    //
    //    }
    //MARK: 获取两个日期之间的间隔,通过日历计算(有一个问题，假如只比较天数的话。)
    func calcTheIntervalBetweenTwoDate(fromDate:Date,toDate:Date)->Int{
        //        let dateFormatter = DateFormatter.init()
        //        dateFormatter.dateFormat = "yyyy年MM月dd日 HH时mm分ss秒 Z"
        //
        //        //第一个日期设置成当前日期好了
        //        let firDate = Date.init()
        //
        //        //第二个日期随手设置一个
        //        let secDateStr = "2017年04月05日 10时03分25秒 +0800"
        //        let secDate = dateFormatter.date(from: secDateStr)
        let calendar = Calendar.current
        let timeInterval = calendar.dateComponents(Set<Calendar.Component>([.day]), from: fromDate, to: toDate)
        print(timeInterval)
        return timeInterval.day ?? 0
    }
    
    
}
