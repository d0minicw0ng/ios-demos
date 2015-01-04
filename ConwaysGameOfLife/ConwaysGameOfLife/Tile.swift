//
//  Tile.swift
//  ConwaysGameOfLife
//
//  Created by Dominic Wong on 4/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit
import SpriteKit

class Tile: SKSpriteNode {
    var isAlive:Bool = false {
        didSet {
            self.hidden = !isAlive
        }
    }
    var numLivingNeighbors = 0
}
