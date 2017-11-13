//
//  TimerModel.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import Foundation

let actions:[String : (TimerModel)->()->Void] = [
    "start":TimerModel.start,
    "stop":TimerModel.stop,
    "lap":TimerModel.lap,
]

class TimerModel{
    
    var timing:Bool = false{
        didSet{
            delegate.enableLap(enabled: timing)
        }
    }
    var delegate:TimerDelegate
    var startingTime:Date?
    var lappedTimes:[Date]! = []
    var timer:Timer!
    
    init(delegate:TimerDelegate){
        print("Timer initiated")
        self.delegate = delegate
        delegate.enableLap(enabled: false)
    }
    
    @objc func updateTime(){
        delegate.undateTime(time: (Date().timeIntervalSince(startingTime!)))
        print("Timer updated")
    }
    
    func start(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        startingTime = Date()
        timing = true
        print("Timer started")
    }
    
    func stop(){
        timing = true
        print("Timer stopped")
    }
    
    func lap(){
        lappedTimes?.insert(Date(), at: 0)
        delegate.reloadTable()
       // print("Timer lapped: \(String(describing: lappedTimes))")
    }
    
    func toggle(action:String){
        print("Timer toggled")
    }
}

protocol TimerDelegate {
    func undateTime(time:Double);
    func enableLap(enabled:Bool);
    func reloadTable();
}
