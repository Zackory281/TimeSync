//
//  TimeClockViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/19/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

class TimeClockViewController: UIViewController {

    @IBOutlet weak var label: UILabel?
    
    func changeClockTime(time:Double){
        label?.text = String(time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
