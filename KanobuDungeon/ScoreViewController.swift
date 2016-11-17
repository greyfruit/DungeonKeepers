//
//  ScoreViewController.swift
//  KanobuDungeon
//
//  Created by Vanya Petrukha on 02.11.16.
//  Copyright © 2016 Vanya Petrukha. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var magesKilledScore: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateScoreBoard()
        
    }
    
    func updateScoreBoard() {
        
        magesKilledScore.text = ("You killed \(magesKilled) mages!")
        
    }
    
    
}
