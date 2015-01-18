//
//  ViewController.swift
//  Music
//
//  Created by Dominic Wong on 18/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func pause(sender: AnyObject) {
        player.pause()
    }
    @IBAction func play(sender: AnyObject) {
        player.play()
    }
    @IBAction func stop(sender: AnyObject) {
        player.stop()
        player.currentTime = 0
    }
    @IBAction func volumeChanged(sender: AnyObject) {
        player.volume = volumeSlider.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var fileLocation = NSBundle.mainBundle().pathForResource("sayuon9scareumad", ofType: "mp3")
        println(fileLocation)
        var error:NSError? = nil
        player = AVAudioPlayer(contentsOfURL: NSURL(string: fileLocation!), error: &error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

