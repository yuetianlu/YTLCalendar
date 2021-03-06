//
//  CalendarCell.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/3/1.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import UIKit
import Foundation

enum CalendarCellType {
    case unknown // 未定义
    case top // 表示顶部
    case header  // 表示头部
    case cell // 表示cell
}

struct CalendarInfo {
    static let topNumber: CGFloat = 5
    static let headerNumber:CGFloat = 7
}
class CalendarCell: UICollectionViewCell {
    var collectionView: UICollectionView?
//        = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        layout.scrollDirection = .horizontal
//        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        view.isPagingEnabled = false
//        view.scrollsToTop = false
//        view.backgroundColor = UIColor.clear
//        view.showsHorizontalScrollIndicator = false
//        return view
//    }()
    let normalLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    let calendarLayout: CalendarCollectionLayout = {
        let style = CalendarCollectionLayoutStyle(numberOfOneRow: 7, rows: 6, width: UIScreen.main.bounds.size.width, height: 260)
        let layout = CalendarCollectionLayout(style)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }()
    var model:CalendarModel = CalendarModel() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    var type: CalendarCellType = .unknown {
        didSet {
            self.updateLayout()
        }
    }
    var collectionWidth: CGFloat = 0
    var collectionHeight: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    fileprivate func makeUI() {

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = self.bounds
        collectionWidth = collectionView?.frame.size.width ?? 0
        collectionHeight = collectionView?.frame.size.height ?? 0
    }
    
    func updateUI() {
        collectionView?.reloadData()
    }
    
    func updateLayout() {
        if collectionView == nil {
            let layout = type == .cell ? calendarLayout : normalLayout
            self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
            if let view = self.collectionView {
                view.isPagingEnabled = false
                view.scrollsToTop = false
                view.showsHorizontalScrollIndicator = false
                view.backgroundColor = UIColor.white
                contentView.addSubview(view)
                view.register(CalendarItemCell.self, forCellWithReuseIdentifier: "CalendarItemCell")
                view.frame = self.bounds
                view.delegate = self
                view.dataSource = self
            }
        }
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: CalendarItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarItemCell", for: indexPath) as? CalendarItemCell {
            cell.model = model.dataArray[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type == .header {
            return CGSize(width: collectionWidth / CalendarInfo.headerNumber, height: collectionHeight)
        }
        if type == .top {
            return CGSize(width: collectionWidth / CalendarInfo.topNumber, height: collectionHeight)
        }
        return CGSize(width: collectionWidth / CalendarInfo.headerNumber, height: collectionHeight / 6)
        
     }
}
struct CalendarCollectionLayoutStyle {
    var numberOfOneRow = 7
    var rows = 6
    var width: CGFloat = UIScreen.main.bounds.size.width
    var height: CGFloat = 260
}
class CalendarCollectionLayout: UICollectionViewFlowLayout {
    // 保存所有item
    fileprivate var attributesArr: [UICollectionViewLayoutAttributes] = []
    fileprivate var style: CalendarCollectionLayoutStyle
    
    init(_ style: CalendarCollectionLayoutStyle) {
        self.style = style
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK:- 重新布局
    override func prepare() {
        super.prepare()
        
        let itemW: CGFloat = (style.width - 2) / CGFloat(style.numberOfOneRow)
        let itemH: CGFloat = style.height / CGFloat(style.rows)
        // 设置itemSize
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = true

        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            page = itemIndex / (style.numberOfOneRow * style.rows)
            // 通过一系列计算, 得到x, y值
            let x = itemSize.width * CGFloat(itemIndex % Int(style.numberOfOneRow)) + (CGFloat(page) * UIScreen.main.bounds.size.width)
            let y = itemSize.height * CGFloat((itemIndex - page * style.rows * style.numberOfOneRow) / style.numberOfOneRow)
            
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来
            attributesArr.append(attributes)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        return rectAttributes
    }
    
}
