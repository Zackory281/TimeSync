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
    var lapColor:UIColor = UIColor.black
    
    init(action: TimerActions,interval:Double,name:String) {
        self.interval = interval
        self.user = name
        self.userAction = action
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
            return Date().timeIntervalSince(self.startTime) + offsetTime
        }
    }
    var offsetTime:Double = 0.0
    var startTime:Date = Date()
    var stopTime:Date = Date()
    var initiateTime:Date = Date()
    var timer:Timer?
    var actorName:String
    var latestAction:TimerActions?
    var database:DatabaseReference
    
    func act(action:TimerActions, time:Date, name:String){
        if let act = latestAction{
            if act != action || act == TimerActions.LAP{
                initiateTime = time
                self.actorName = name
                userActions.insert(Action(action:action, interval: elapsedTime,name: actorName), at: 0)
                actions[action]?(self)()
            }
        }else{
            initiateTime = time
            self.actorName = name
            userActions.insert(Action(action:action, interval: elapsedTime,name: actorName), at: 0)
            actions[action]?(self)()
        }
        latestAction = action
        writeAction(action: Action(action:action, interval: elapsedTime,name: actorName))
        delegate.reloadTable()
    }
    
    func act(action:TimerActions, time:Date){
        act(action: action, time: time, name:USERNAME)
    }
    
    func start(){
        timer = getTimer()
        startTime = initiateTime
    }
    
    func stop(){
        timer?.invalidate()
        stopTime = initiateTime
        offsetTime = elapsedTime
    }
    
    func resume(){
        start()
    }
    
    func lap(){
    }
    
    func reset(){
        offsetTime = 0
        self.delegate.updateTime(time: getFormattedString(interval:0))
    }
    
    init(delegate:TimerDelegate){
        self.delegate = delegate
        delegate.enableLap(enabled: true)
        actorName = USERNAME
        database = Database.database().reference()
        database.observe(.childAdded, with: { (snapshot) -> Void in
            //self.comments.append(snapshot)
            //self.tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            //print("the changed child was \(postDict["user"])")
        })
    }
    
    @objc func updateTime(){
        self.delegate.updateTime(time: elapsedTime)
        self.delegate.updateTime(time: getFormattedString(interval:elapsedTime))
    }
    
    func getTimer() -> Timer{
        let timer = Timer.scheduledTimer(timeInterval: 1/FPS, target: self, selector: (#selector(self.updateTime)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        return timer
    }
    
    func writeAction(action:Action){
        let roomReference = database.child(ROOMID).child("lastAction")
        roomReference.child("time").setValue(action.interval)
        roomReference.child("user").setValue(action.user)
        roomReference.child("action").setValue(actionLabelToString[action.userAction])
        //roomReference.child("time").setValue(action)
    }
}

protocol TimerDelegate {
    func updateTime(time:String);
    func updateTime(time:Double);
    func enableLap(enabled:Bool);
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
