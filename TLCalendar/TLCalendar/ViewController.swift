//
//  ViewController.swift
//  TLCalendar
//
//  Created by yuetianlu on 2019/2/28.
//  Copyright © 2019年 yuetianlu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CalendarManager.manager.setupCalendarData()
        let calendar = CalendarView(frame: CGRect(x: 0, y: 90, width: view.frame.width, height:400))
        view.addSubview(calendar)
        print(CalendarManager.manager.dataArray)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

