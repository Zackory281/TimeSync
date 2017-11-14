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
    "resume":TimerModel.resume,
    "reset":TimerModel.reset,
    "stop":TimerModel.stop,
    "lap":TimerModel.lap,
]

struct Lap {
    
    let startingTime:Date!
    let lappedTime:Date!
    let interval:TimeInterval
    let str:String
    
    init(start:Date, lap:Date) {
        self.startingTime = start
        self.lappedTime = lap
        interval = lappedTime.timeIntervalSince(start)
        let seconds = uint(interval * 100.0) % 60
        let mins = uint(interval) % 60
        let hours = uint(interval / 100.0) % 60
        str = "\(hours):\(mins).\(seconds)"
    }
    
}

class TimerModel{
    
    var timing:Bool = false
    var canLap:Bool = false
    var delegate:TimerDelegate
    var startingTime:Date?
    var lapStartTime:Date?
    var offsetSeconds:TimeInterval?
    var lappedTimes:[Lap]! = []
    var timer:Timer?
    
    init(delegate:TimerDelegate){
        print("Timer initiated")
        self.delegate = delegate
        delegate.enableLap(enabled: false)
    }
    
    @objc func updateTime(){
        self.delegate.undateTime(time: Double((Date().timeIntervalSince(self.startingTime!))))
    }
    
    func start(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        startingTime = Date()
        lapStartTime = Date()
        timing = true
        canLap = true
    }
    
    func resume(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        startingTime = Date(timeIntervalSinceNow: offsetSeconds!)
        lapStartTime = Date()
        timing = true
    }
    
    func reset(){
        self.timer?.invalidate()
        timing = false
        canLap = false
    }
    
    func stop(){
        self.timer?.invalidate()
        offsetSeconds = startingTime?.timeIntervalSinceNow
        timing = false
        print("Timer stopped")
    }
    
    func lap(){
        lappedTimes?.insert(Lap(start:lapStartTime!, lap:Date()), at: 0)
        lapStartTime = Date()
        delegate.reloadTable()
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
