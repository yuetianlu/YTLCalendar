//
//  CalendarItemModel.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/2/28.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import Foundation
import UIKit

class CalendarModel {
    var number: Int = 0 // 月
    var index: Int = 0  // 索引
    var dataArray: [CalendarItemModel] = [] // 本月数据
}

class CalendarItemModel {
    var isNowDay: Bool = false   // 是否当天
    var isSelected: Bool = false  // 是否选中
    var index: Int = 0  // 索引
    var type: TLCalendarType = .calendarTypeUnknown // 类型
    var date: Date = Date.init()  // 当前日期
    var weekday: String  = ""  // 星期
    var month: String = "" // 月份
    var year: String = ""  // 年份
    
    init() {
        
    }
}

enum TLCalendarType {
    case calendarTypeUnknown               // 未定义
    case calendarTypeUp                    // 上月
    case calendarTypeCurrent               // 当前月
    case calendarTypeDown                  // 下月
    case calendarTypeWeek                  // 表示星期选项
    case calendarTypeMonth                 // 表示点击月份
    case calendarTypeItemSlide             // 表示滑动日期
    case calendarTypeTopSlide              // 表示头部滑动
}
