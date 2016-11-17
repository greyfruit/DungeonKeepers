//
//  kanobu.swift
//  KaNoBu
//
//  Created by Vanya Petrukha on 25.10.16.
//  Copyright © 2016 Vanya Petrukha. All rights reserved.
//

import Foundation

public enum Choice {
    
    case water, fire, earth
    
}

public enum Answer {
    
    case firstWin, secondWin, tie
    
}

class Player {
    
    let name: String
    
    var currentChoice: Choice!
    
    var currentDamage: Int
    
    var maxHealth: Int = 100
    
    private var _health : Int = 100
    
    var health: Int {
        
        get {
            
            return _health
        }
        
        set {
            
            if newValue > maxHealth {
                
                self._health = 100
                
            } else if newValue < 0 {
                
                self._health = 0
                
            } else {
                
                self._health = newValue
                
            }
        }
    }
    
    init(playerName: String, damage: Int) {
        
        self.name = playerName
        self.currentDamage = damage
    }
    
    func addHealth(amount: Int) {
        
        self.health += amount
    }
    
    func removeHealth(amount: Int) {
        
        self.health -= amount
    }
}

func randomName() -> String {
    
    let random: [Int] = [Int(arc4random_uniform(2)),Int(arc4random_uniform(2)),Int(arc4random_uniform(2))]
    
    let namePrefix = ["Mo", "Ro", "Sin"]
    let nameMiddle = ["bo", "wos", "net"]
    let nameSuffix = ["o", "u", "a"]
    
    let name = namePrefix[random[0]]+nameMiddle[random[1]]+nameSuffix[random[2]]
    
    return name
    
}

class Computer: Player {
    
    init(damage: Int) {
        
        super.init(playerName: randomName(), damage: damage)
    }
 
    func makeChoice() {
        
        let random = arc4random_uniform(3)
        
        switch random {
            
        case 0:
            self.currentChoice = .water
            
        case 1:
            self.currentChoice = .fire
            
        case 2:
            self.currentChoice = .earth
            
        default:
            break
        }
    }
}


class Human: Player {
    
    var criticalDamage: Double = 1.0
    
    var currentLevel: Int = 1
    
    var magesKilled: Int = 0

    var _currentXP: Int = 0
    
    var currentXP: Int {
        
        get {
            
            return _currentXP
        }
        
        set {
            
            if newValue > 100 {
                
                self._currentXP = 100
                
            } else if newValue < 0 {
                
                self._currentXP = 0
                
            } else {
                
                self._currentXP = newValue
                
            }
        }
    }
    
    var _currentDamage: Int = 8
    
    override var currentDamage: Int {
        
        get {
            
            return (_currentDamage + (currentLevel * 8))
        }
        
        set {
            
            self._currentDamage = newValue
        }
    }
    
    func levelUp() {
        
        self.currentLevel += 1
    }
    
    func setCurrentChoice(choice: Choice) {
        
        switch choice {
            
        case .water:
            self.currentChoice = .water
            
        case .fire:
            self.currentChoice = .fire
            
        case .earth:
            self.currentChoice = .earth
        }
    }
}


class Game {
    
    var winner: Answer!
    
    var currentStep: Int = 0
    
    var isPrevWinner: Bool = false
    
    var currentRoundReslut: String = ""
    
    func round(player: Human, computer: Computer, playerChoice: Choice) {
        
        computer.makeChoice()
        
        player.setCurrentChoice(choice: playerChoice)
        
        player.criticalDamage = 1.0
        
        switch compare(first: player.currentChoice, second: computer.currentChoice) {
            
        case .firstWin:
            
            if isPrevWinner {
                
                isPrevWinner = false
                
            } else {
                
                isPrevWinner = true
                
            }
            
            player.criticalDamage = 1.0                        
            
            winner = Answer.firstWin
            
        case .secondWin:
            
            isPrevWinner = false
            
            winner = Answer.secondWin
            
        case .tie:
            
            isPrevWinner = false
            
            winner = Answer.tie
        }
    }
    
    private func compare(first: Choice, second: Choice) -> Answer {
        
        switch (first, second) {
            
        case (.water, .fire):
            return .firstWin
            
        case (.fire, .earth):
            return .firstWin
            
        case (.earth, .water):
            return .firstWin
            
        case _ where first == second:
            return .tie
            
        default:
            return .secondWin
        }
    }
    
}
