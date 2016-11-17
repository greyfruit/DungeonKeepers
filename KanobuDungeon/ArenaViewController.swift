//
//  ArenaViewController.swift
//  KanobuDungeon
//
//  Created by Vanya Petrukha on 31.10.16.
//  Copyright © 2016 Vanya Petrukha. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ArenaViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            if let scene = SKScene(fileNamed: "BattleScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        
        }
        
        var shouldAutorotate: Bool {
            return true
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Release any cached data, images, etc that aren't in use.
        }
        
    }
    
}

