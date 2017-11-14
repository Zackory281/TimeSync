//
//  TimerViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController,UITableViewDataSource, TimerDelegate{
    
    var tableView:UITableView?
    
    func reloadTable() {
        tableView?.reloadData()
        tableView?.endUpdates()
    }
    
    func enableLap(enabled: Bool) {
        leftButton!.isEnabled = enabled
    }
    
    func undateTime(time: Double) {
        timeLabel.text? = String((time*100.0).rounded()/100.0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return timer?.lappedTimes.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell")! as! TimeTableViewCell
        cell.label!.text! = String(describing:(timer?.lappedTimes[indexPath.row])!.str)
        return cell
    }
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    var timer:TimerModel?
    
    @IBAction func toggle(_ sender: UIButton) {
        let text = String(describing: sender.titleLabel!.text!)
        print("this button says: \(text)");
        actions[text]?(timer!)()
        var lapAva:Bool = true
        if(text=="start"){
            lapAva = true
            leftButton.setTitle("lap", for: .normal)
            rightButton.setTitle("stop", for: .normal)
        }else if(text=="stop"){
            leftButton.setTitle("reset", for: .normal)
            rightButton.setTitle("resume", for: .normal)
        }else if(text=="reset"){
            lapAva = true
            leftButton.setTitle("lap", for: .normal)
            rightButton.setTitle("start", for: .normal)
        }else if(text=="resume"){
            lapAva = true
            leftButton.setTitle("lap", for: .normal)
            rightButton.setTitle("stop", for: .normal)
        }
        if(lapAva){
            leftButton.isEnabled = (timer?.canLap)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = TimerModel(delegate:self)
        tableView?.dataSource = self
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
