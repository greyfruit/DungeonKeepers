//
//  BattleScene.swift
//  KanobuDungeon
//
//  Created by Vanya Petrukha on 31.10.16.
//  Copyright © 2016 Vanya Petrukha. All rights reserved.
//

import SpriteKit
import GameplayKit

class BattleScene: SKScene {
    
    public var waterChar: SKNode?
    
    override func didMove(to view: SKView) {
        
        waterChar = self.childNode(withName: "waterChar") as? SKSpriteNode
        self.addChild(waterChar!)
        
    }
    
    func newFunc() {
        
    }
}
