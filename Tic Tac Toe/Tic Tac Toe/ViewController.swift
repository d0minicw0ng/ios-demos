//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Dominic Wong on 16/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // odd = nought's turn, even = cross' turn
    var goNumber = 1
    // 0 = empty, 1 = nought, 2 = cross
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    let winningCombinations = [
        // horizontal
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        // vertical
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        // diagonal
        [0, 4, 8],
        [2, 4, 6]
    ]
    var winner = 0
    @IBOutlet weak var winnerAnnoucement: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    @IBAction func playAgainPressed(sender: AnyObject) {
        goNumber = 1
        winner = 0
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        winnerAnnoucement.alpha = 0
        playAgain.alpha = 0
        
        var button : UIButton
        for var i = 1; i < 10; i++ {
            button = view.viewWithTag(i) as UIButton
            button.setImage(nil, forState: .Normal)
        }
    }
    
    @IBOutlet weak var button0: UIButton!
    @IBAction func buttonPressed(sender : AnyObject) {
        if (gameState[sender.tag - 1] == 0 && winner == 0) {
            var image = UIImage()
            if (goNumber % 2 == 0) {
                image = UIImage(named: "cross.png")!
                gameState[sender.tag - 1] = 2
            } else {
                image = UIImage(named: "nought.png")!
                gameState[sender.tag - 1] = 1
            }
            
            for combination in winningCombinations {
                if (gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] && gameState[combination[0]] != 0) {
                    winner = gameState[combination[0]]
                }
            }
            
            if (winner != 0) {
                if (winner == 1) {
                    winnerAnnoucement.text = "Noughts has won!"
                } else {
                    winnerAnnoucement.text = "Crosses has won!"
                }
                
                UIView.animateWithDuration(0.4, animations: {
                    self.winnerAnnoucement.alpha = 1
                    self.playAgain.alpha = 1
                })
            }
            
            var boardIsFull = true
            for var i = 0; i < 9; i++ {
                if gameState[i] == 0 {
                    boardIsFull = false
                }
            }

            if (winner == 0 && boardIsFull) {
                winnerAnnoucement.text = "It is a DRAW!"
                UIView.animateWithDuration(0.4, animations: {
                    self.winnerAnnoucement.alpha = 1
                    self.playAgain.alpha = 1
                })
            }
            
            goNumber++
            sender.setImage(image, forState: .Normal)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        winnerAnnoucement.alpha = 0
        playAgain.alpha = 0
    }


}

