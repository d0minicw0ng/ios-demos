//
//  ViewController.swift
//  SoundShaker
//
//  Created by Dominic Wong on 19/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    var effects = ["applause", "fart", "gunshot", "helicopter"]

    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if event.subtype == UIEventSubtype.MotionShake {
            var randomNumber = Int(arc4random_uniform(UInt32(effects.count)))
            var fileLocation = NSBundle.mainBundle().pathForResource(effects[randomNumber], ofType: "mp3")
            var error:NSError? = nil
            player = AVAudioPlayer(contentsOfURL: NSURL(string: fileLocation!), error: &error)
            player.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

