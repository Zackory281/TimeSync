//
//  TimerModel.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore

var USERNAME:String = "user"
var ROOMID:String = "room1"

enum TimerActions{
    case START
    case STOP
    case RESUME
    case LAP
    case RESET
}

let actionLabel:[String:TimerActions] = [
    "start"  : TimerActions.START,
    "stop"   : TimerActions.STOP,
    "resume" : TimerActions.RESUME,
    "lap"    : TimerActions.LAP,
    "reset"  : TimerActions.RESET,
]

let actionLabelToString:[TimerActions:String] = [
    TimerActions.START  : "start" ,
    TimerActions.STOP   : "stop"  ,
    TimerActions.RESUME : "resume",
    TimerActions.LAP    : "lap"   ,
    TimerActions.RESET  : "reset" ,
]

let actionLabelToColor:[TimerActions:UIColor] = [
    TimerActions.START  : UIColor.green ,
    TimerActions.STOP   : UIColor.red ,
    TimerActions.RESUME : UIColor.green ,
    TimerActions.LAP    : UIColor.blue  ,
    TimerActions.RESET  : UIColor.darkGray ,
]

let actions:[TimerActions : (TimerModel)->()->Void] = [
    TimerActions.START : TimerModel.start,
    TimerActions.STOP : TimerModel.stop,
    TimerActions.RESUME : TimerModel.resume,
    TimerActions.LAP : TimerModel.lap,
    TimerActions.RESET : TimerModel.reset,
]

let FPS:Double = 50

struct Action {
    
    let interval:TimeInterval
    let str:String
    let user:String
    let userAction:TimerActions
    let timeInitiated:Date
    var lapColor:UIColor{
        return actionLabelToColor[userAction]!
    }
    
    init(action: TimerActions,initiated: Date,interval:Double,name:String) {
        self.interval = interval
        self.user = name
        self.userAction = action
        self.timeInitiated = initiated
        str = getFormattedString(interval: interval)
    }
    
}

func getFormattedString(interval:Double) -> String{
    let str = String(format: "%02d:%02d.%02d", arguments: [uint(interval / 60) % 60, uint(interval) % 60, uint(interval * 60.0) % 60])
    return str
}

class TimerModel{
    
    var canLap:Bool = true
    var delegate:TimerDelegate
    var userActions:[Action]! = []
    
    var elapsedTime:Double{
        get{
            return isTiming ? offsetTime + (Date().timeIntervalSince(self.startTime)) : userActions.first?.interval ?? 0.0
        }
    }
    var offsetTime:Double = 0.0
    var startTime:Date = Date()
    var initiateTime:Date = Date()
    var isTiming = false
    var timer:Timer?
    var actorName:String
    var latestAction:TimerActions = TimerActions.STOP
    var database:DatabaseReference
    var dateformatter:DateFormatter!
    
    func act(action:TimerActions, time:Date, name:String){
        let toActAction = Action(action:action, initiated: time, interval: elapsedTime,name: actorName)
        if latestAction != action || action == TimerActions.LAP{
            initiateTime = time
            self.actorName = name
            writeAction(action: toActAction)
        }
        latestAction = action
    }
    
    func act(action:TimerActions, timeInitiated:Date){
        act(action: action, time: Date(), name:USERNAME)
    }
    
    func processAction(action:Action){
        initiateTime = action.timeInitiated
        actions[action.userAction]?(self)()
        delegate.buttonSetting(mode: actionLabelToString[action.userAction]!)
    }
    
    func start(){
        timer = getTimer()
        startTime = initiateTime
        isTiming = true
    }
    
    func stop(){
        timer?.invalidate()
        offsetTime = elapsedTime
        isTiming = false
        //updateEndTime(time: userActions.last!.interval)
    }
    
    func resume(){
        start()
    }
    
    func lap(){
    }
    
    func reset(){
        offsetTime = 0
        isTiming = false
        updateTime()
    }
    
    init(delegate:TimerDelegate){
        self.delegate = delegate
        delegate.enableLap(enabled: true)
        actorName = USERNAME
        database = Database.database().reference()
        dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
        database.child(ROOMID).observe(.childChanged, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            let cmd:String = postDict["cmd"] as! String
            let arr = cmd.components(separatedBy: "|")
            let actionToAdd = Action(action:actionLabel[arr[1]]!, initiated: self.dateformatter.date(from: arr[3])!, interval: Double(arr[2])!,name: arr[0])
            self.userActions.insert(actionToAdd, at: 0)
            self.processAction(action: actionToAdd)
            self.delegate.reloadTable()
        })
    }
    
    @objc func updateTime(){
        self.delegate.updateTime(time: elapsedTime)
        self.delegate.updateTime(time: getFormattedString(interval:elapsedTime))
    }
    
    func updateEndTime(time:Double){
        self.delegate.updateTime(time: 10)
        self.delegate.updateTime(time: getFormattedString(interval:time))
    }
    
    func getTimer() -> Timer{
        let timer = Timer.scheduledTimer(timeInterval: 1/FPS, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        return timer
    }
    
    func writeAction(action:Action){
        let roomReference = database.child(ROOMID).child("lastAction")
        var interval = action.interval//\(action.interval)
        if action.userAction == .RESET {
            interval = 0.0
        }
        let actionString:NSString = "\(action.user)|\(actionLabelToString[action.userAction]!)|\(interval)|\(dateformatter.string(from: action.timeInitiated))" as NSString
        roomReference.child("cmd").setValue("\(action.user)|\(actionLabelToString[action.userAction]!)|\(interval)|\(dateformatter.string(from: action.timeInitiated))")
        //roomReference.child("history").setValue("\("fdas")~\(actionString)")
        //roomReference.child("user").setValue(action.user)
        //roomReference.child("action").setValue(actionLabelToString[action.userAction])
        //roomReference.child("time").setValue(action)
    }
}

protocol TimerDelegate {
    func updateTime(time:String);
    func updateTime(time:Double);
    func enableLap(enabled:Bool);
    func buttonSetting(mode:String);
    func reloadTable();
}

/*
 func start(){
 self.timer = Timer.scheduledTimer(timeInterval: 1/FPS, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
 RunLoop.main.add(timer!, forMode: .commonModes)
 startingTime = Date()
 lapStartTime = Date()
 lapOffsetSeconds = 0.0
 timing = true
 canLap = true
 }
 
 func resume(){
 self.timer = Timer.scheduledTimer(timeInterval: 1/FPS, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
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
 */
