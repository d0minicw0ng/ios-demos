//
//  TinderViewController.swift
//  Tinder
//
//  Created by Dominic Wong on 25/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {
    @IBOutlet weak var findingMoreUsers: UILabel!
    
    var xFromCenter:CGFloat = 0
    var usernames = [String]()
    var userImages = [NSData]()
    var currentCandidate = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                var currentUser = PFUser.currentUser()
                currentUser["location"] = geopoint
                
                var query:PFQuery = PFUser.query()
                query.whereKey("location", nearGeoPoint: geopoint)
                query.limit = 10;
                query.findObjectsInBackgroundWithBlock({ (candidates: [AnyObject]!, error: NSError!) -> Void in
                    
                    if error == nil {
                        var accepted = currentUser["accepted"] as [String]
                        var rejected = currentUser["rejected"] as [String]
                        
                        for candidate in candidates {
                            let candidateGender = candidate["gender"] as? NSString
                            let candidateUsername = candidate["username"] as? NSString
                            let currentUserPreferredGender = currentUser["interestedIn"] as? NSString
                            if candidateGender! == currentUserPreferredGender && currentUser.username != candidate.username && !contains(accepted, candidateUsername!) &&
                                !contains(rejected, candidateUsername!) {
                                
                                self.usernames.append(candidate.username)
                                self.userImages.append(candidate["image"] as NSData)
                            }

                        }
                        
                        if self.userImages.count > 0 {
                            self.addCandidateImage(self.userImages[0])
                        } else {
                            self.findingMoreUsers.alpha = 1
                        }
                    }
                })
                
                currentUser.save()
            }
        }
    
//        var i = 10
//        
//        func addPerson(urlString: String) {
//            var newUser = PFUser()
//            let url = NSURL(string: urlString)
//            let urlRequest = NSURLRequest(URL: url!)
//            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
//                response, data, error in
//
//                newUser["image"] = data
//                newUser["gender"] = "female"
//                
//                var lat = Double(37 + i)
//                var lon = Double(-122 + i)
//                var location = PFGeoPoint(latitude: lat, longitude: lon)
//                i = i + 10
//                
//                newUser["location"] = location
//                newUser.username = "Girl Bot \(i)"
//                newUser.password = "password"
//                newUser.signUp()
//            })
//        }
        
//        addPerson("http://s3.amazonaws.com/readers/2010/12/07/3186885154021fda16b1_1.jpg")
//        addPerson("http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840")
//        addPerson("http://i263.photobucket.com/albums/ii139/whatgloom/janejetson.jpg")
//        addPerson("http://www.scrapwallpaper.com/wp-content/uploads/2014/08/female-cartoon-characters-pictures-6.jpg")
//        addPerson("http://diaryofalagosmumblog.files.wordpress.com/2011/11/smurfette-scaled500.gif")
    }
    
    func addCandidateImage(data: NSData) {
        //var candidateImage:UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        var candidateImage:UIImageView = UIImageView(frame: CGRectMake(self.view.bounds.width / 2 - 100, 100, 200, 200))
        candidateImage.image = UIImage(data: data)
        candidateImage.contentMode = .ScaleAspectFill
        self.view.addSubview(candidateImage)
        var gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        candidateImage.addGestureRecognizer(gestureRecognizer)
        candidateImage.userInteractionEnabled = true
        self.view.addSubview(candidateImage)
    }
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(self.view)
        var candidateImage = gestureRecognizer.view!
        xFromCenter += translation.x
        var scale = min(100 / abs(xFromCenter), 1)
        candidateImage.center = CGPoint(x: candidateImage.center.x + translation.x, y: candidateImage.center.y + translation.y)
        gestureRecognizer.setTranslation(CGPointZero, inView: self.view)
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        candidateImage.transform = stretch
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            var currentUser = PFUser.currentUser()
            if candidateImage.center.x < 100 {
                currentUser.addUniqueObject(self.usernames[self.currentCandidate], forKey: "rejected")
                currentUser.save()
                currentCandidate++
            } else if candidateImage.center.x > self.view.bounds.width - 100 {
                currentUser.addUniqueObject(self.usernames[self.currentCandidate], forKey: "accepted")
                currentUser.save()
                currentCandidate++
            }

            candidateImage.removeFromSuperview()
            xFromCenter = 0
            if currentCandidate < self.userImages.count {
                addCandidateImage(self.userImages[currentCandidate])
            } else {
                findingMoreUsers.alpha = 1
            }
        }
    }
}
