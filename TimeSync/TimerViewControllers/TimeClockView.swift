//
//  TimeClockView.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/20/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

@IBDesignable
class TimeClockView: UIScrollView {

    enum componets {
        case 
    }
    let BIG_TICK_MARK_STARTING_RATIO:CGFloat = 0.8 / 2.0
    let BIG_TICK_MARK_ENDING_RATIO:CGFloat = 0.92 / 2.0
    
    let MID_TICK_MARK_STARTING_RATIO:CGFloat = 0.85 / 2.0
    let MID_TICK_MARK_ENDING_RATIO:CGFloat = 0.9 / 2.0
    
    let SML_TICK_MARK_STARTING_RATIO:CGFloat = 0.87 / 2.0
    let SML_TICK_MARK_ENDING_RATIO:CGFloat = 0.9 / 2.0
    
    override func draw(_ rect: CGRect) {
        let bez = UIBezierPath()
        bez.addArc(withCenter: self.center, radius: 70, startAngle: 0, endAngle: 3.14/2.0, clockwise: true)
        bez.stroke()
        let viewWidth:CGFloat = self.bounds.width
        let center = self.center
        for i in 1...300 {
            let angle = CGFloat.pi * CGFloat(Double(i) / (5.0 * 5.0 * 6.0))
            let xRatio:CGFloat = cos(angle)
            let yRatio:CGFloat = sin(angle)
            
            let strokeStartPosX:CGFloat!
            let strokeStartPosY:CGFloat!
            let strokeEndPosX:CGFloat!
            let strokeEndPosY:CGFloat!
            let tickStartRatio:CGFloat
            let tickEndRatio:CGFloat
            switch i {
            case let i where i % (5 * 5) == 0:
                print("hoi")
                tickStartRatio = BIG_TICK_MARK_STARTING_RATIO
                tickEndRatio = BIG_TICK_MARK_ENDING_RATIO
            case let i where i % 5 == 0:
                print("sdf")
                tickStartRatio = MID_TICK_MARK_STARTING_RATIO
                tickEndRatio = MID_TICK_MARK_ENDING_RATIO
            default:
                tickStartRatio = SML_TICK_MARK_STARTING_RATIO
                tickEndRatio = SML_TICK_MARK_ENDING_RATIO
            }
            strokeStartPosX = xRatio * viewWidth * tickStartRatio + center.x
            strokeStartPosY = yRatio * viewWidth * tickStartRatio + center.y
            strokeEndPosX = xRatio * viewWidth * tickEndRatio + center.x
            strokeEndPosY = yRatio * viewWidth * tickEndRatio + center.y
            bez.move(to: CGPoint(x: strokeStartPosX, y: strokeStartPosY))
            bez.addLine(to: CGPoint(x: strokeEndPosX, y: strokeEndPosY))
            bez.stroke()
        }
    }

}
