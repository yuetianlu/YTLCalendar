//
//  CalendarView.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/3/1.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    let topLab: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    let monthsViewContent: CalendarCell = CalendarCell()
    let weeksViewContent: CalendarCell = CalendarCell()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.scrollsToTop = false
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    var dataArray: [CalendarModel] = CalendarManager.manager.dataArray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dataArray = CalendarManager.manager.dataArray
        makeUI()
        updateItem()
    }
    
    fileprivate func makeUI() {
        addSubview(topLab)
        addSubview(monthsViewContent)
        addSubview(weeksViewContent)
        addSubview(collectionView)
        topLab.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        monthsViewContent.frame = CGRect(x: 50, y: 0, width: self.frame.width - 50, height: 50)
        weeksViewContent.frame = CGRect(x: 0, y: 50, width: self.frame.width, height: 40)
        collectionView.frame = CGRect(x: 0, y: 90, width: self.frame.width, height:260)
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // 设置月份
        monthsViewContent.type = .top
        monthsViewContent.model = CalendarManager.manager.topModel
        
        // 设置头部
        weeksViewContent.type = .header
        weeksViewContent.model = CalendarManager.manager.headerModel
        
        let selectItem = CalendarManager.manager.selectedMonthModel
        // 设置年份
        topLab.text = selectItem?.year
        
        collectionView.reloadData()
    }
    
    func updateItem() {
        CalendarManager.manager.itemUpdateBlock { [weak self] (type) in
            guard let `self` = self else { return }
            for view in self.collectionView.subviews {
                if let cell = view as? CalendarCell {
                    cell.updateUI()
                }
            }
            let selectItem = CalendarManager.manager.selectedItemModel
            let monthItem = CalendarManager.manager.selectedMonthModel
            switch type {
            case .calendarTypeUp, .calendarTypeDown:
                 self.reloadCell(selectItem, type: type)
            case .calendarTypeMonth, .calendarTypeItemSlide:
                self.topLab.text = monthItem?.year
                self.reloadCell(monthItem, type: type)
                self.monthsViewContent.updateUI()
            default:
                return
            }
        }
    }
    
    func reloadCell(_ model:CalendarItemModel?, type: TLCalendarType) {

        if let selectIndex = model?.index, selectIndex >= 0, selectIndex < KCalendarMonthCount {
            let indexPath = IndexPath(row: selectIndex, section:0)
            if type != .calendarTypeItemSlide {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            if type == .calendarTypeMonth || type == .calendarTypeItemSlide {
                monthsViewContent.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: CalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell {
            cell.model = dataArray[indexPath.row]
            cell.type = .cell
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        CalendarManager.manager.updateSelectedMonthIndex(Int(currentPage))
    }
}

