//
//  TimerModel.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import Foundation

class Timer{
    var counting:Bool = false
    var delegate:TimerDelegate
    var startingTime:Date?
    var lappedTimes:[Date]?
    
    init(delegate:TimerDelegate){
        print("Timer initiated")
        self.delegate = delegate
    }
    
    func start(){
        startingTime = Date()
    }
    
    func toggle(){
        print("Timer toggled")
    }
    
    func lap(){
        print("Timer lapped")
    }
}

protocol TimerDelegate {
    func undateTime(time:Int);
}
