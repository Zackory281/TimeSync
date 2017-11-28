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
    
    @IBOutlet var clockBackground: TimeClockView?
    @IBOutlet weak var clockNeedle: UIView?
    @IBOutlet weak var timeLabel: UILabel?
    
    func changeClockTime(time:Double){
        //guard !(self.clockNeedle?.isHidden)! else {return}
        UIView.animate(withDuration: 0.1) {
            self.clockNeedle?.transform = CGAffineTransform(rotationAngle: CGFloat(time.remainder(dividingBy: 60.0) / 30.0 * Double.pi))
        }
        let formattedTime = getFormattedString(interval: time)
        let nStr = NSMutableAttributedString(string: formattedTime)
        //nStr.addAttribute
        nStr.addAttribute(.kern, value: 1.0, range: NSRange(location: 0, length: formattedTime.count))
        timeLabel?.attributedText = nStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockNeedle?.backgroundColor = UIColor.clear
        NSLayoutConstraint(item: timeLabel!, attribute: .centerY, relatedBy: .equal, toItem: clockBackground!, attribute: .centerY, multiplier: 1.3, constant: 0.0).isActive = true
        //NSLayoutConstraint(item: timeLabel, attribute: .centerX, relatedBy: .equal, toItem: clockBackground, attribute: .centerX, multiplier: 0.5, constant: 0.0).isActive = true
        //view.addConstraint()
    }

}
