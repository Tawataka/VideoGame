//
//  EndScreen.swift
//  VideoGame
//
//  Created by Tawa Reyna on 3/3/19.
//  Copyright © 2019 Tawa Reyna. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

class EndScreen: SKScene {
    
    var endscreen: SKEmitterNode!
    var playAgainNode: SKSpriteNode!
    var finalScore: SKLabelNode!
   
    var restartSound = AVAudioPlayer()
    var score:Int = 0
    var FScore: Int = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(displayP3Red: 116/255, green: 93/255, blue: 73/255, alpha: 1)
    
        endscreen = SKEmitterNode(fileNamed: "gameover")
        endscreen.position = CGPoint(x: self.frame.midX, y: self.frame.minY - 40)
        self.addChild(endscreen)
        endscreen.advanceSimulationTime(400)
        endscreen.zPosition = -2
        
        playAgainNode = SKSpriteNode(imageNamed: "restart_button")
        playAgainNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 350)
        playAgainNode.zPosition = 1
        self.addChild(playAgainNode)
        
        finalScore = SKLabelNode(text: "Final Score: \(score)")
        finalScore.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 150)
        finalScore.fontName = "AmericanTypewriter-Bold"
        finalScore.fontSize = 65
        finalScore.fontColor = UIColor.black
        finalScore.zPosition = 1
        self.addChild(finalScore)
        
        checkIfHighScore()
        
    }
    
    func checkIfHighScore(){
        
            FScore = UserDefaults.standard.object(forKey: "big") as! Int
            
            if(score > FScore){
                FScore = score
                
                UserDefaults.standard.set(FScore, forKey: "big")
                let homescreen = homeScreen(size: self.size)
                
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                self.view?.presentScene(homescreen, transition: transition)
                
            }
            
        
        
        
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointTouched = touch.location(in: self)
            
            if playAgainNode.contains(pointTouched) {
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .fill
                
                let trueFalse = (UserDefaults.standard.object(forKey: "mute")) as! Bool
                if(trueFalse){
                    
                    let path = Bundle.main.path(forResource: "jump", ofType : "mp3")!
                    let url = URL(fileURLWithPath : path)
                    
                    do {
                        self.restartSound = try AVAudioPlayer(contentsOf: url)
                        self.restartSound.play()
                        
                    } catch {
                        print ("There is an issue with this code!")
                    }
                }
                self.view?.presentScene(gameScene, transition: transition)
                
            }
        }
        
        
    }
    
}
