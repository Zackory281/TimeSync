//
//  TimeClockViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/19/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit
import SpriteKit

class TimeClockViewController: UIViewController {
    
    @IBOutlet var clockBackground: TimeClockView!
    @IBOutlet weak var clockNeedle: UIView?
    @IBOutlet weak var timeLabel: UILabel!
    
    func changeClockTime(time:Double){
        UIView.animate(withDuration: 0.1) {
            self.clockNeedle?.transform = CGAffineTransform(rotationAngle: CGFloat(time.remainder(dividingBy: 60.0) / 30.0 * Double.pi))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockNeedle?.backgroundColor = UIColor.clear
        //NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: clockBackground, attribute: .centerY, multiplier: 1.3, constant: 0.0).isActive = false
        //view.addConstraint()
    }

}
