//
//  CalendarItemCell.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/3/1.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import UIKit

class CalendarItemCell: UICollectionViewCell {
    
    var label:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = UIColor.gray
        view.textAlignment = .center
        return view
    }()
    var btn: UIButton = UIButton(type: .custom)
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 10
        return view
    }()
    
    var model: CalendarItemModel = CalendarItemModel() {
        didSet {
            self.updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    fileprivate func makeUI() {
        contentView.addSubview(bgView)
        contentView.addSubview(label)
        contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(buttonSelect), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 10, y: 10, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 20)
        label.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.height)
        btn.frame = label.frame
    }
    func updateUI() {
        label.text = "\(model.date.day())"
        bgView.isHidden = true
        switch model.type {
        case .calendarTypeUp, .calendarTypeDown:
            label.textColor = UIColor.lightGray
        case .calendarTypeCurrent:
            if model.isNowDay {
                label.textColor = UIColor.red
                label.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                label.textColor = UIColor.lightGray
            }
            if model.isSelected {
                bgView.isHidden = false
                label.textColor = UIColor.white
                label.font = UIFont.systemFont(ofSize: 17)
                
                // 添加简易动画
                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.duration = 0.15
                animation.repeatCount = 1
                animation.autoreverses = true
                animation.fromValue = 1
                animation.toValue = 1.1
                bgView.layer.add(animation, forKey: "scale-layer")
            } else {
                bgView.isHidden = true
            }
        case .calendarTypeWeek:
            label.text = model.weekday
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.lightGray
        case .calendarTypeMonth:
            label.text = model.month
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = model.isSelected ? UIColor.red : UIColor.gray
        default:
            label.textColor = UIColor.red
        }
    }
    
    @objc func buttonSelect() {
        CalendarManager.manager.updateSelectedItemModel(self.model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
