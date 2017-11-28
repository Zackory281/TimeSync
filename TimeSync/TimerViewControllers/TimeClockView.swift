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

    var clockTimeSec:Double?
    
    let NUMOFNIPS:Int = 12 * 5 * 3
    
    override func draw(_ rect: CGRect) {
        let viewWidth:CGFloat = self.bounds.width
        let center = self.center
        for i in 1...NUMOFNIPS {
            let bez = UIBezierPath()
            let angle = CGFloat.pi * CGFloat(Double(i) / Double(NUMOFNIPS) * 2.0)
            let xRatio:CGFloat = cos(angle)
            let yRatio:CGFloat = sin(angle)
            
            let strokeStartPosX:CGFloat!
            let strokeStartPosY:CGFloat!
            let strokeEndPosX:CGFloat!
            let strokeEndPosY:CGFloat!
            let tickStartRatio:CGFloat
            let tickEndRatio:CGFloat
            switch i {
            case let i where i % (5 * 3) == 0:
                print(i)
                tickStartRatio = BIG_TICK_MARK_STARTING_RATIO
                tickEndRatio = BIG_TICK_MARK_ENDING_RATIO
                let paragraphStyle = NSMutableParagraphStyle()
                var strToAdd = String(((i + 45) % 180 / (3)))
                if strToAdd == "0"{
                    strToAdd = "60"
                }
                paragraphStyle.alignment = .center
                let textFontAttributes = [
                    NSAttributedStringKey.font: UIFont(name: "Avenir",size: 18)!,
                    NSAttributedStringKey.foregroundColor: UIColor.blue,
                    NSAttributedStringKey.paragraphStyle: paragraphStyle,
                ]
                let w:CGFloat = NSString(string: strToAdd).size(withAttributes: textFontAttributes).width
                let h:CGFloat = NSString(string: strToAdd).size(withAttributes: textFontAttributes).height
                let xC = xRatio * viewWidth * tickStartRatio * 0.85 + center.x
                let yC = yRatio * viewWidth * tickStartRatio * 0.85 + center.y
                let textRect = CGRect(x: xC - w / 2.0, y: yC - h / 2.0, width: w, height: h)
                strToAdd.draw(in: textRect, withAttributes: textFontAttributes)
                UIColor.black.setStroke()
                bez.lineWidth = 1.0
                break
            case let i where i % 3 == 0:
                tickStartRatio = MID_TICK_MARK_STARTING_RATIO
                tickEndRatio = MID_TICK_MARK_ENDING_RATIO
                bez.lineWidth = 1.0
                UIColor.lightGray.setStroke()
                break
            default:
                tickStartRatio = SML_TICK_MARK_STARTING_RATIO
                tickEndRatio = SML_TICK_MARK_ENDING_RATIO
                bez.lineWidth = 1.0
                UIColor.lightGray.setStroke()
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

let BIG_TICK_MARK_STARTING_RATIO:CGFloat = 0.8 / 2.2
let BIG_TICK_MARK_ENDING_RATIO:CGFloat = 0.9 / 2.2

let MID_TICK_MARK_STARTING_RATIO:CGFloat = 0.8 / 2.2
let MID_TICK_MARK_ENDING_RATIO:CGFloat = 0.9 / 2.2

let SML_TICK_MARK_STARTING_RATIO:CGFloat = 0.85 / 2.2
let SML_TICK_MARK_ENDING_RATIO:CGFloat = 0.9 / 2.2

@IBDesignable
class TimeNeedleView: UIView {
    
    var clockTimeSec:Double?
    
    override func draw(_ rect: CGRect) {
        let bez = UIBezierPath()
        let cir = UIBezierPath()
        bez.move(to: CGPoint(x: self.center.x, y: self.center.y - 3))
        bez.addLine(to: CGPoint(x: self.center.x, y:(self.center.y - self.bounds.width * MID_TICK_MARK_ENDING_RATIO)))//self.bounds.width * SML_TICK_MARK_STARTING_RATIO * 0.9
        bez.move(to: CGPoint(x: self.center.x, y: self.center.y + 3))
        bez.addLine(to: CGPoint(x: self.center.x, y:self.center.y + 12))
        cir.addArc(withCenter: self.center, radius: 3, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        cir.stroke()
        bez.stroke()
    }
    
}

/*@IBDesignable
class TimeNeedleView: UIView {
    
    var clockTimeSec:Double = 0
    
    func setTime(time:Double){
        clockTimeSec = time
        //self.setNeedsDisplay()
        UIView.animate(withDuration: 0.1, animations: self.)
    }
    
    override func draw(_ rect: CGRect) {
        let bez = UIBezierPath()
        bez.addArc(withCenter: self.center, radius: 100, startAngle: 0, endAngle: CGFloat(3), clockwise: true)
        bez.stroke()
    }
    
}*/

