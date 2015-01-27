//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by Dominic Wong on 27/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        createBackground()
        createBird()
    }
    
    func createBackground() {
        var backgroundTexture = SKTexture(imageNamed: "images/bg.png")
        var moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)
        var replaceBackground = SKAction.moveByX(900, y: 0, duration: 0)
        var moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for var i:CGFloat = 0; i < 3; i++ {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position  = CGPoint(x: backgroundTexture.size().width / 2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame))
            background.size.height = self.frame.height
            
            background.runAction(moveBackgroundForever)
            self.addChild(background)
        }
    }
    
    func createBird() {
        var birdTexture = SKTexture(imageNamed: "images/flappy1.png")
        var birdTextureTwo = SKTexture(imageNamed: "images/flappy2.png")
        var animation = SKAction.animateWithTextures([birdTexture, birdTextureTwo], timePerFrame: 0.1)
        var makeBirdFlap = SKAction.repeatActionForever(animation)
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        self.addChild(bird)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
