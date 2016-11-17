//
//  ViewController.swift
//  KanobuDungeon
//
//  Created by Vanya Petrukha on 27.10.16.
//  Copyright © 2016 Vanya Petrukha. All rights reserved.
//

import UIKit
import Foundation

class BattleViewController: UIViewController {
    
    @IBOutlet weak var enemyNameLabel: UILabel!
    
    @IBOutlet weak var playerHealthBar: UIProgressView!
    
    @IBOutlet weak var computerHealthBar: UIProgressView!
    
    @IBOutlet weak var computerHealthLabel: UILabel!
    
    @IBOutlet weak var playerHealthLabel: UILabel!
    
    @IBOutlet weak var roundResultLabel: UILabel!
    
    @IBOutlet weak var waterChar: UIImageView!
    
    @IBOutlet weak var fireChar: UIImageView!
    
    @IBOutlet weak var earthChar: UIImageView!
    
    @IBOutlet weak var computerChar: UIImageView!
    
    @IBOutlet var choseButtons: [UIButton]!
    
    @IBOutlet weak var computerRemovingHealthLabel: UILabel!
    
    @IBOutlet weak var playerRemovingHealthLabel: UILabel!
    
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var scoreBackground: UIImageView!
    
    @IBOutlet weak var magesKilledLabel: UILabel!
    
    @IBOutlet weak var computerElement: UIImageView!
    
    @IBOutlet weak var playerElement: UIImageView!
    
    @IBOutlet weak var multiplierView: UIView!
    
    @IBOutlet weak var multiplierLabel: UILabel!
    
    @IBOutlet weak var currentLevelLabel: UILabel!
    
    @IBOutlet weak var xpPlayerBar: UIProgressView!
    
    var tempX: CGFloat!
    var tempY: CGFloat!
    
    var game = Game()
    
    var player = Human(playerName: "Player", damage: 14)
    
    var computer = Computer(damage: 8)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.installRoundedScore()
        
        self.installLevelSystem()
        
        self.setHealthBars()
        
        self.installMultiplierView()
        
        self.enemyNameLabel.text = computer.name
        
    }
    
    @IBAction func endGameButton(_ sender: AnyObject) {
    
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func choseWater(_ sender: AnyObject) {
        
        changeButtonsState()
        game.round(player: player, computer: computer, playerChoice: .water)
        makeFight(target: self.waterChar)
        
    }

    @IBAction func choseFire(_ sender: AnyObject) {
        
        changeButtonsState()
        game.round(player: player, computer: computer, playerChoice: .fire)
        makeFight(target: self.fireChar)
        
    }
    
    @IBAction func choseEarth(_ sender: AnyObject) {
        
        changeButtonsState()
        game.round(player: player, computer: computer, playerChoice: .earth)
        makeFight(target: self.earthChar)
        
    }
    
    @IBAction func addMultiplier(_ sender: AnyObject) {
        
        player.criticalDamage += 0.1
        self.multiplierLabel.text = String(player.criticalDamage)
        
    }
    
    func installLevelSystem() {
        
        self.currentLevelLabel.text = "\(player.currentLevel) lvl."
        
        self.xpPlayerBar.setProgress(Float(Float(player.currentXP)/100), animated: true)
    }
    
    func installMultiplierView() {
        
        self.multiplierView.backgroundColor = UIColor(patternImage: UIImage(named: "tapper")!)
    }
    
    func setHealthBars() {
        
        playerHealthBar.setProgress(Float(Float(player.health)/100), animated: true)
        
        computerHealthBar.setProgress(Float(Float(computer.health)/100), animated: true)
    }
    
    func installRoundedScore() {
        
        let maskPath = UIBezierPath(roundedRect: self.scoreBackground.bounds, cornerRadius: CGFloat(7.0))
        let maskLayer = CAShapeLayer(layer: maskPath)
        
        maskLayer.frame = self.scoreBackground.bounds
        maskLayer.path = maskPath.cgPath
        
        self.scoreView.center.x += self.view.bounds.width
        self.scoreBackground.layer.mask = maskLayer
    }
    
    func showScoreBoard() {
        
        magesKilledLabel.text = ("\(player.magesKilled)")
        
        UIView.animate(withDuration: 0.7, animations: {
            self.scoreView.center.x -= self.view.bounds.width
            }, completion: nil)
    }
    
    func updateRoundStatus() {
        
        if player.health == 0 {
            
            roundResultLabel.text = "GAME END\nComputer WIN!"
            showScoreBoard()
            
        } else if computer.health == 0 {
            
            roundResultLabel.text = "NICE\nKill them all!"
            player.currentXP += 25 + Int(arc4random_uniform(25))
            if player.currentXP == 100 {
                player.levelUp()
                player.currentXP = 0
            }
            updateLevelLabel()
            updatePlayerXP()
            player.magesKilled += 1
            player.addHealth(amount: (5 + Int(arc4random_uniform(4))))
            computer = Computer(damage: (10 + Int(arc4random_uniform(4))))
            enemyNameLabel.text = computer.name
            changeButtonsState()
            
        } else {
            
            roundResultLabel.text = game.currentRoundReslut
            changeButtonsState()
        }
        
        updatePlayerHealth()
        playerHealthLabel.text = "\(player.health)/100"
        updateComputerHealth()
        computerHealthLabel.text = "\(computer.health)/100"
        
    }
    
    private func updateLevelLabel() {
        
        self.currentLevelLabel.text = "\(player.currentLevel) lvl."
    }
    
    private func updatePlayerHealth() {
        
        playerHealthBar.setProgress(Float(Float(player.health)/100), animated: true)
    }
    
    private func updateComputerHealth() {
        
        computerHealthBar.setProgress(Float(Float(computer.health)/100), animated: true)
    }
    
    private func updatePlayerXP() {
        
        xpPlayerBar.setProgress(Float(Float(player.currentXP)/100), animated: true)
    }
    
    func makeFight(target: UIView) {
        
        saveOriginalPoints(target: target)
        
        self.multiplierLabel.text = "TAP"

        UIView.animate(withDuration: 0.3, animations: {

            self.goToBattle(target: target)
            
            self.switchMageChar(target: self.computer)

            }, completion: {

                finished in
                
                self.setPlayerElements()
                
                self.setElementsPriority()
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.showElements()
                    self.showMultiplier()
                    
                }, completion: {

                    finished in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.3,  animations: {
                        
                        self.presentElements()
                        
                    }, completion: {

                        finished in
                        
                        let timeDelay = (self.game.winner == .firstWin) ? 4 : 0
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timeDelay), execute: {
                        
                            UIView.animate(withDuration: 0.5, animations: {
                            
                            self.showHealthLabels()
                            self.hideMultiplier()
                            
                        }, completion: {
                            
                        finished in
                            
                            self.removeRoundHealth()
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                
                                self.hideHealthLabels()
                                self.hideElements()
                                
                                }, completion: {
                                    
                                    finished in
                                    
                                    UIView.animate(withDuration: 0.3, animations: {
                                        
                                        self.goOutBattle(target: target)
                                        
                                        self.computerChar.alpha = 0.0
                                        self.computerChar.image = UIImage(named: "computerChar")
                                        self.computerChar.alpha = 1.0
                                        
                                    })
                                    
                                    self.restoreElements()
                                    self.updateRoundStatus()
                            })
                        })
                    })
                })
             }
        )})
    }
    
    func showHealthLabels() {
        
        self.playerRemovingHealthLabel.text = String(computer.currentDamage)
        self.computerRemovingHealthLabel.text = String(player.currentDamage * Int(player.criticalDamage))
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.computerRemovingHealthLabel.alpha = 1.0
                
            case .secondWin:
                self.playerRemovingHealthLabel.alpha = 1.0
                
            case .tie:
                break
            }
        }
    }
    
    func hideHealthLabels() {
        
        self.playerRemovingHealthLabel.alpha = 0.0
        self.computerRemovingHealthLabel.alpha = 0.0
    }
    
    func removeRoundHealth() {
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.computer.removeHealth(amount: Int(self.player.currentDamage * Int(self.player.criticalDamage)))
                self.game.currentRoundReslut = ("Player WIN!\n\(Int(player.criticalDamage))X DAMAGE!\nHit by \(self.player.currentDamage * Int(self.player.criticalDamage))")
                
            case .secondWin:
                self.player.removeHealth(amount: self.computer.currentDamage)
                self.game.currentRoundReslut = ("Computer WIN!\nHit by \(self.computer.currentDamage)")
                
            case .tie:
                self.game.currentRoundReslut = ("TIE!")
            }
        }
    }
    
    func hideElements() {
        
        self.playerElement.alpha = 0.0
        self.computerElement.alpha = 0.0
    }
    
    func restoreElements() {
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.playerElement.center.x -= 38
                
            case .secondWin:
                self.computerElement.center.x += 38
                
            default:
                break
            }
        }
    }
    
    func setElementsPriority() {
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.view.bringSubview(toFront: self.playerElement)
                
            case .secondWin:
                self.view.bringSubview(toFront: self.computerElement)
                
            default:
                break
            }
        }
    }
    
    func setPlayerElements() {
        
        if let pElement = self.getPlayerElementImage(){
            
            if let cElement = self.getComputerElementImage(){

                self.playerElement.image = pElement
                self.computerElement.image = cElement
            }
        }
    }
    
    func showMultiplier() {
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.multiplierView.alpha = 0.0
                self.multiplierView.isHidden = false
                self.multiplierView.alpha = 1.0
                
            default:
                break
            }
        }
    }
    
    func hideMultiplier() {
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.multiplierView.alpha = 1.0
                self.multiplierView.alpha = 0.0
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { self.multiplierView.isHidden = true})
                
            default:
                break
            }
        }
    }
    
    func getPlayerElementImage() -> UIImage? {
        
        let element: UIImage?
        
        if let choice = player.currentChoice {
            
            switch choice {
                
            case .water:
                element = UIImage(named: "water")
                
            case .fire:
                element = UIImage(named: "fire")
                
            case .earth:
                element = UIImage(named: "earth")
            }
            
            return element
            
        } else {
            
            return nil
        }
    }
    
    func getComputerElementImage() -> UIImage? {
        
        let element: UIImage?
        
        if let choice = computer.currentChoice {
            
            switch choice {
                
            case .water:
                element = UIImage(named: "water")
                
            case .fire:
                element = UIImage(named: "fire")
                
            case .earth:
                element = UIImage(named: "earth")
            }
            
            return element
            
        } else {
            
            return nil
        }
    }
    
    func showElements() {
        
        self.playerElement.alpha = 1.0
        self.computerElement.alpha = 1.0
    }
    
    func presentElements() {
        
        if let winner = self.game.winner {
            
            switch winner {
                
            case .firstWin:
                self.playerElement.center.x += 38
                
            case .secondWin:
                self.computerElement.center.x -= 38
                
            default:
                break
            }
        }
    }
    
    func presentRemovingHealth() {
        
        if let winner = self.game.winner {
            
            self.computerRemovingHealthLabel.text = ("-\(player.currentDamage)")
            self.playerRemovingHealthLabel.text = ("-\(computer.currentDamage)")
            
            switch winner {
                
            case .firstWin:
                self.computerRemovingHealthLabel.alpha = 0.0
                self.computerRemovingHealthLabel.alpha = 1.0
                
            case .secondWin:
                self.playerRemovingHealthLabel.alpha = 0.0
                self.playerRemovingHealthLabel.alpha = 1.0
                
            default:
                break
            }
        }
    }
    
    func changeButtonsState() {
        
        for button in choseButtons {
            
            if button.isEnabled {
                
                button.isEnabled = false
            } else {
                
                button.isEnabled = true
            }
        }
    }
    
    func saveOriginalPoints(target: UIView) {
        
        tempX = target.center.x
        tempY = target.center.y
    }
    
    func switchMageChar(target: Computer) {
        
        self.computerChar.alpha = 0.0
        
        if let choice = target.currentChoice{
            
            var imageChar: UIImage?
            
            switch choice {
                
            case .water :
                imageChar = UIImage(named: "waterCharReversed")
                
            case .fire :
                imageChar = UIImage(named: "fireCharReversed")
                
            case .earth :
                imageChar = UIImage(named: "earthCharReversed")
            }
            
            computerChar.image = imageChar
        }
        
        self.computerChar.alpha = 1.0
    }
    
    private func goToBattle(target: UIView) {

        target.center.x = (self.computerChar.center.x - self.computerChar.bounds.width)
        target.center.y = self.computerChar.center.y
    }
    
    private func goOutBattle(target: UIView) {
        
        target.center.x = tempX
        target.center.y = tempY
    }
    
}

