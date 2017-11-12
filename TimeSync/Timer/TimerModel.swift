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
    
    init(){
        print("Timer initiated")
    }
    
    func toggle(){
        print("Timer toggled")
    }
    
    func lap(){
        print("Timer lapped")
    }
}
