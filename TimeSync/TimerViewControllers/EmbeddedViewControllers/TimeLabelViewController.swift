//
//  TimeLabelViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/18/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

class TimeLabelViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    func changeLabelTime(time:String){
        //timeLabel.text = time
        let string = NSMutableAttributedString(string: time)
        string.addAttribute(.kern, value: 1.0, range: NSRange(location: 0, length: time.count))
        timeLabel.attributedText = string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.numberOfLines = 1;
        timeLabel.minimumScaleFactor = 0.1
        timeLabel.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
