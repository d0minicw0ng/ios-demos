//
//  ViewController.swift
//  StopWatch
//
//  Created by Dominic Wong on 12/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var time: UILabel!
    var count = 0
    var timer = NSTimer()
    
    @IBAction func play(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick"),
            userInfo: nil, repeats: true)
    }
    
    @IBAction func pause(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBAction func reset(sender: AnyObject) {
        timer.invalidate()
        count = 0
        time.text = String(count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tick() {
        count++
        time.text = String(count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

