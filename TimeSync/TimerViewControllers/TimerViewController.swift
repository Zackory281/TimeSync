//
//  TimerViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit
import Firebase

class TimerViewController: UIViewController,UITableViewDataSource, TimerDelegate{
    
    var tableView:UITableView?
    var connection:Connection?
    var pageViewController:TimerPageViewController?
    
    @IBAction func connectToFirebase(_ sender: Any) {
        
        //let ref = Database.database().reference()
        //ref.child("pussy/da").childByAutoId().setValue("hi")
        //pageViewController?.changeLabelTime(time: "pussy!")
    }
    
    func reloadTable() {
        tableView?.reloadData()
        tableView?.endUpdates()
    }
    
    func enableLap(enabled: Bool) {
        leftButton!.isEnabled = enabled
    }
    
    func updateTime(time: String) {
        pageViewController?.changeLabelTime(time: time)
    }
    
    func updateTime(time: Double) {
        pageViewController?.changeLabelTime(time: time)
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
        let lap = (timer?.lappedTimes[indexPath.row])!
        cell.label!.text! = String(describing:lap.str)
        cell.label!.textColor = lap.lapColor
        return cell
    }
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
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
        
        //connection = Connection()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TimerPageViewController{
            pageViewController = vc
        }
    }
}
