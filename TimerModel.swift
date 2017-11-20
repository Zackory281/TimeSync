//
//  TimerModel.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import Foundation
import UIKit

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
    var lapColor:UIColor = UIColor.black
    
    init(start:Date, lap:Date) {
        self.startingTime = start
        self.lappedTime = lap
        interval = lappedTime.timeIntervalSince(start)
        str = getFormattedString(interval: interval)
    }
    
}

func getFormattedString(interval:Double) -> String{
    let str = String(format: "%02d:%02d.%02d", arguments: [uint(interval / 60) % 60, uint(interval) % 60, uint(interval * 60.0) % 60])
    let mins = String(uint(interval) % 60)
    let hours = String(uint(interval / 60) % 60)
    //let stsr = "\(hours):\(mins).\(seconds)"
    return str
}

class TimerModel{
    
    var timing:Bool = false
    var canLap:Bool = false
    var delegate:TimerDelegate
    var startingTime:Date?
    var lapStartTime:Date?
    var offsetSeconds:TimeInterval?
    var lapOffsetSeconds:TimeInterval?
    var lappedTimes:[Lap]! = []
    var timer:Timer?
    var edgeTimes:[Lap] = []
    
    init(delegate:TimerDelegate){
        self.delegate = delegate
        delegate.enableLap(enabled: false)
    }
    
    @objc func updateTime(){
        self.delegate.updateTime(time: (Date().timeIntervalSince(self.startingTime!)))
        self.delegate.updateTime(time: getFormattedString(interval: Date().timeIntervalSince(self.startingTime!)))
    }
    
    func start(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        startingTime = Date()
        lapStartTime = Date()
        lapOffsetSeconds = 0.0
        timing = true
        canLap = true
    }
    
    func resume(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
        startingTime = Date(timeIntervalSinceNow: offsetSeconds!)
        lapStartTime = Date(timeIntervalSinceNow: lapOffsetSeconds!)
        lapOffsetSeconds = 0.0
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
        lapOffsetSeconds = lapStartTime?.timeIntervalSinceNow
        timing = false
    }
    
    func lap(){
        var newLap = Lap(start:lapStartTime!, lap:Date())
        if(edgeTimes.count == 0){
            edgeTimes.append(newLap)
        }else if(edgeTimes.count == 1){
            if(edgeTimes[0].interval > newLap.interval){
                newLap.lapColor = UIColor.green
                edgeTimes.insert(newLap,at: 0)
            }else{
                newLap.lapColor = UIColor.red
                edgeTimes.append(newLap)
            }
        }else if(edgeTimes[0].interval > newLap.interval){
            edgeTimes[0] = newLap
            newLap.lapColor = UIColor.green
        }else if(edgeTimes[1].interval < newLap.interval){
            edgeTimes[1] = newLap
            newLap.lapColor = UIColor.red
        }
        lapStartTime = Date()
        offsetSeconds = 0.0
        lappedTimes?.insert(newLap, at: 0)
        newLap.lapColor = UIColor.green
        delegate.reloadTable()
    }
    
    func toggle(action:String){
    }
}

protocol TimerDelegate {
    func updateTime(time:String);
    func updateTime(time:Double);
    func enableLap(enabled:Bool);
    func reloadTable();
}
