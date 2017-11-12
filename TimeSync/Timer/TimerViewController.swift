//
//  TimerViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, TimerDelegate{
    
    func undateTime(time: Int) {
    }
    
    var timer:Timer?
    
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer(delegate:self)
    }
    @IBAction func lap(_ sender: Any) {
        timer?.lap() ?? print("timer not initiated?")
    }
    @IBAction func toggle(_ sender: Any) {
        timer?.toggle() ?? print("timer not initiated?")
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
