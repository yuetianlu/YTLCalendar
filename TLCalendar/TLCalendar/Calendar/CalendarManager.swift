//
//  CalendarManager.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/2/28.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import Foundation
import UIKit

let KCalendarMonthCount: Int = 18

class CalendarManager {
    
    static var manager: CalendarManager {
        struct StructWrapper {
            static var instance = CalendarManager()
        }
        return StructWrapper.instance
    }

    var beganDate: Date {
//        var now = Date()
//        // 获取系统s时区
//        let zone = NSTimeZone.system
//        let time = zone.secondsFromGMT(for: now)
//        now = now.addingTimeInterval(TimeInterval(time))
//        print("----当前时间----\(now)")
        let now = Date.formatDate("2018-12-09")
        return now
    }
    var nowDate: Date {
        var now = Date()
        // 获取系统s时区
        let zone = NSTimeZone.system
        let time = zone.secondsFromGMT(for: now)
        now = now.addingTimeInterval(TimeInterval(time))
        print("----当前时间----\(now)")
        return now
    }

    var selectedItemModel: CalendarItemModel? // 当前被选中的日期
    var selectedMonthModel: CalendarItemModel? // 当前被选中的月份
    var dataArray: [CalendarModel] = [] // 日期数据模型
    var headerModel: CalendarModel = CalendarModel() // 头部数据模型
    var topModel: CalendarModel = CalendarModel() // 顶部数据模型
    
    var block: ((TLCalendarType) -> ())?
    
    func setupCalendarData() {
        setupDataArray()
        setupHeaderModel()
        setupTopModel()
    }
    
    // MARK: update
    // 根据月份索引改变月份
    func updateSelectedMonthIndex(_ index: Int) {
        if let selectIndex = selectedMonthModel?.index, index != selectIndex {
            // 更新数据
            selectedMonthModel?.isSelected = false
            let item = topModel.dataArray[index]
            item.isSelected = true
            selectedMonthModel = item
            // 通知回调
            block?(.calendarTypeItemSlide)
        }
    }
    
    // 根据选中item改变数据
    func updateSelectedItemModel(_ model: CalendarItemModel) {
        if let _ = selectedItemModel {
            // 如果点击上月或下月图标，滚动到对应页面
            switch model.type {
            case .calendarTypeCurrent:
                updateCurrentModel(model)
                block?(.calendarTypeCurrent)
            case .calendarTypeUp:
                if model.index > 0 {
                    // 获取上月数据
                    let upModel = dataArray[model.index - 1]
                    for upItem in upModel.dataArray {
                        if upItem.date.isSameDay(model.date) && upItem.type == .calendarTypeCurrent { // 前一月对应的日期
                            updateCurrentModel(upItem)
                            block?(.calendarTypeUp)
                        }
                    }
                }
            case .calendarTypeDown:
                if model.index < KCalendarMonthCount - 1 {
                    // 获取上月数据
                    let downModel = dataArray[model.index + 1]
                    for downItem in downModel.dataArray {
                        if downItem.date.isSameDay(model.date) && downItem.type == .calendarTypeCurrent { // 前一月对应的日期
                            updateCurrentModel(downItem)
                            block?(.calendarTypeDown)
                        }
                    }
                }

            case .calendarTypeMonth:
                if let selectIndex = selectedMonthModel?.index, model.index != selectIndex {
                    selectedMonthModel?.isSelected = false
                    let item: CalendarItemModel = topModel.dataArray[model.index]
                    item.isSelected = true
                    selectedMonthModel = item
                    block?(.calendarTypeMonth)
                    print("-----当前选中月份\(model.month)")
                }
            default:
                return
            }
        }
    }
    
    func itemUpdateBlock(_ block: @escaping ((TLCalendarType) -> ())) {
        self.block = block
    }
}

extension CalendarManager {
    
    fileprivate func updateCurrentModel(_ model: CalendarItemModel) {
        let oldModel = selectedItemModel
        oldModel?.isSelected = false
        let newModel = model
        newModel.isSelected = true
        selectedItemModel = newModel
        print("-----当前选中：\(newModel.date.string())----上次选中：\(String(describing: oldModel?.date.string()))")
    }
    
    fileprivate func setupDataArray() {
        var mDataArray:[CalendarModel] = []
        for i in 0..<KCalendarMonthCount {
            var mItemArray: [CalendarItemModel] = []
            // 当月
            let curDate = self.beganDate.dateAfterMonth(i)
            // 当月大小
            let curMonthSize = curDate.daysInMonth()
            
            
            // 当月第一天
            let beginDate = curDate.begindayOfMonth()
            // 当月第一天对应的星期
            let weekIndex = beginDate.weekday()
            // 当月第一天如果是周日，默认从第二排开始
            let upSize = weekIndex == 1 ? 7 : weekIndex - 1
            
            //当月第一天日期前移upSize天，得到当月记录的第一天（从上月开始记录）
            let startDate = beginDate.dateAfterDay(-upSize)
            // 记录游标
            var cursor = 0
            //记录上月日期的部分
            for _ in 0..<upSize {
                let item = CalendarItemModel()
                item.index = i
                item.date = startDate.dateAfterDay(cursor)
                item.type = .calendarTypeUp
                mItemArray.append(item)
                cursor += 1
            }
            // 记录当月日期部分
            for _ in 0..<curMonthSize {
                
                let item = CalendarItemModel()
                item.index = i
                item.date = startDate.dateAfterDay(cursor)
                item.type = .calendarTypeCurrent
                if item.date.isSameDay(self.nowDate) { // 判断是否是今天
                    item.isNowDay = true
                    selectedItemModel = item
                    selectedItemModel?.isSelected = true
                }
                mItemArray.append(item)
                cursor += 1
            }
            // 记录下月日期部分
            let downSize = 42 - upSize - curMonthSize // 剩下天数
            for _ in 0..<downSize {
                
                let item = CalendarItemModel()
                item.index = i
                item.date = startDate.dateAfterDay(cursor)
                item.type = .calendarTypeDown
                mItemArray.append(item)
                cursor += 1
            }
            
            let model = CalendarModel()
            model.index = i    // 设置索引
            model.number = curDate.month() // 设置当前月
            model.dataArray = mItemArray  // 设置当前日期
            mDataArray.append(model)
        }
        dataArray = mDataArray
    }
    
    fileprivate func setupHeaderModel() {
        let model = CalendarModel()
        var dataArray: [CalendarItemModel] = []
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        for str in weekdays {
            let item = CalendarItemModel()
            item.weekday = str
            item.type = .calendarTypeWeek
            dataArray.append(item)
        }
        model.dataArray = dataArray
        headerModel = model
    }
    
    fileprivate func setupTopModel() {
        let model = CalendarModel()
        var dataArray: [CalendarItemModel] = []
        for i in 0..<KCalendarMonthCount {
            let item = CalendarItemModel()
            // 获取下一月
            let upDate = self.beganDate.dateAfterMonth(i)
            item.index = i
            item.month = "\(upDate.month())月"
            item.year = "\(upDate.year())"
            item.type = .calendarTypeMonth
            if i == 0 {
                item.isSelected = true
                selectedMonthModel = item
            }
            dataArray.append(item)
        }
        model.dataArray = dataArray
        topModel = model
    }

}
