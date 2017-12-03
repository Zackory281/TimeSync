//
//  TimerViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/11/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit
import Firebase

class TimerViewController: UIViewController, TimerDelegate, SettingsDelegate{
    
    func dismissView() {
        UIView.animate(withDuration: 0.5){
            self.settingsView.alpha = 0
            self.blurEffectView.effect = self.blurEffect!
            self.settingsView.center.x = 0 - self.settingsView.bounds.width / 2.0
        }
    }
    
    var tableView:UITableView?
    var connection:Connection?
    var pageViewController:TimerPageViewController?
    var timeTableViewController:TimeTableViewController?
    var blurEffect:UIBlurEffect?
    
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet var settingsView: UIView!
    @IBOutlet weak var roomIDLabel: UIPlaceHolderTextField!
    @IBOutlet weak var usernameLabel: UIPlaceHolderTextField!
    
    @IBAction func joinRoom(_ sender: Any) {
        USERNAME = usernameLabel.text!
        ROOMID = roomIDLabel.text!
        resetTimer()
        dismissView()
        self.view.endEditing(true)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func panGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let x = sender.location(in: self.view).x
        let xr = x / self.view.bounds.width
        switch sender.state {
        case .began:
            loadSettings()
        case .changed:
            UIView.animate(withDuration: 0.1){
                self.settingsView.center = self.view.center
                self.settingsView.center.x = x - self.settingsView.bounds.width / 2.0
                self.settingsView.alpha = xr
                //self.blurEffectView.e
                
                //ffect = self.blurEffect!
            }
        case .ended:
            UIView.animate(withDuration: 0.5){
                self.settingsView.center = sender.velocity(in: self.view).x > 0 ? self.view.center:CGPoint.init(x: 0 - self.settingsView.bounds.width / 2.0, y: self.view.center.y)
                self.settingsView.alpha = 1
                self.blurEffectView.effect = self.blurEffect!
            }
        default:
            break;
        }
    }
    
    func loadSettings(){
        settingsView.center = self.view.center
        //settingsView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        settingsView.alpha = 0
        settingsView.layer.cornerRadius = 8
        /*UIView.animate(withDuration: 0.5){
            self.settingsView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.settingsView.alpha = 1
            self.blurEffectView.effect = self.blurEffect!
        }*/
    }
    
    func reloadTable() {
        timeTableViewController?.tableView.reloadData()
        timeTableViewController?.tableView.endUpdates()
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
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var timer:TimerModel?
    
    @IBAction func toggle(_ sender: UIButton) {
        let text = String(describing: sender.titleLabel!.text!)
        timer!.act(action: (actionLabel[text])!, timeInitiated: Date())//(action: (actionLabel[text])!, time: Date())//act(action:TimerActions, timeInitiated:Date)
    }
    
    func buttonSetting(mode:String){
        var lapAva:Bool = true
        if(mode=="start"){
            lapAva = true
            leftButton.setTitle("lap", for: .normal)
            rightButton.setTitle("stop", for: .normal)
        }else if(mode=="stop"){
            leftButton.setTitle("reset", for: .normal)
            rightButton.setTitle("resume", for: .normal)
        }else if(mode=="reset"){
            lapAva = true
            leftButton.setTitle("lap", for: .normal)
            rightButton.setTitle("start", for: .normal)
        }else if(mode=="resume"){
            lapAva = true
            leftButton.setTitle("lap", for: .normal)
            rightButton.setTitle("stop", for: .normal)
        }
        if(lapAva){
            leftButton.isEnabled = (timer?.canLap)!
        }
    }
    
    func resetTimer(){
        timer = TimerModel(delegate:self)
        timeTableViewController!.timer = timer
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect = blurEffectView.effect as? UIBlurEffect
        blurEffectView.effect = nil
        settingsView.alpha = 0
        resetTimer()
        self.view.addSubview(settingsView)
    }
    
    override func viewDidLayoutSubviews() {
        timer?.updateTime()
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
        }else if let vc = segue.destination as? TimeTableViewController{
            timeTableViewController = vc
        }
    }
}
