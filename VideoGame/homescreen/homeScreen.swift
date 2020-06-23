//
//  homeScreen.swift
//  VideoGame
//
//  Created by Tawa Reyna on 3/2/19.
//  Copyright © 2019 Tawa Reyna. All rights reserved.
//

import SpriteKit
import AVFoundation
import UIKit
import GoogleMobileAds

class homeScreen: SKScene {
    
    var mainScreen: SKEmitterNode!
    var newGameNode: SKSpriteNode!
    var tittle: SKLabelNode!
    var highScore: SKLabelNode!
    var muteOnNode: SKSpriteNode!
    var muteOffNode: SKSpriteNode!
    //var rewardBassedVideo: GADRewardBasedVideoAd!
    
    //var viewController: GameViewController!
    
    var button = AVAudioPlayer()
    
    var FScore: Int = 0
    var bigScore: Int = 0
    var muteCount: Int = 2
    var livecount: Int = 1
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(displayP3Red: 137/255, green: 217/255, blue: 222/255, alpha: 1)
        
        UserDefaults.standard.set(true, forKey: "mute")
        
        UserDefaults.standard.set(livecount, forKey: "liveCount")
        
        //UserDefaults.standard.set( 0, forKey: "big")
         if( UserDefaults.standard.object(forKey: "big") == nil){
            UserDefaults.standard.set(FScore, forKey: "big")
        }
        
        if( UserDefaults.standard.object(forKey: "big") != nil){
            FScore = UserDefaults.standard.object(forKey: "big") as! Int
        
        }
        
        
        mainScreen = SKEmitterNode(fileNamed: "mainScreen")
        mainScreen.position = CGPoint(x: frame.midX + 500, y: frame.midY)
        mainScreen.advanceSimulationTime(40)
        self.addChild(mainScreen)
        mainScreen.zPosition = -2
        
        newGameNode = SKSpriteNode(imageNamed: "newGameButton")
        newGameNode.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 350)
        newGameNode.zPosition = 1
        self.addChild(newGameNode)
        
        
        tittle = SKLabelNode(text: "GiRaFFe")
        tittle.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 170)
        tittle.fontName = "AmericanTypewriter-Bold"
        tittle.fontSize = 100
        tittle.fontColor = UIColor.black
        tittle.zPosition = 1
        self.addChild(tittle)
        
        
        highScore = SKLabelNode(text: " High Score: \(FScore)")
        highScore.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 450)
        highScore.fontName = "AmericanTypewriter-bold"
        highScore.fontSize = 60
        highScore.fontColor = UIColor.black
        highScore.zPosition = 1
        self.addChild(highScore)
        
        muteOnNode = SKSpriteNode(imageNamed: "mute_on")
        muteOnNode.position = CGPoint(x: self.frame.maxX - 70, y: self.frame.minY + 70)
        muteOnNode.zPosition = 2
        self.addChild(muteOnNode)
        
        muteOffNode = SKSpriteNode(imageNamed: "mute_off")
        muteOffNode.position = CGPoint(x: self.frame.maxX - 70, y: self.frame.minY + 70)
        muteOffNode.zPosition = 3
        self.addChild(muteOffNode)
        muteOffNode.removeFromParent()
        
        let endscreen = EndScreen(size: self.size)
        endscreen.FScore = self.FScore
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: AnyObject in touches {
            let pointTouched = touch.location(in: self)
            
            if muteOnNode.contains(pointTouched){
                
            
                if (muteCount % 2 == 0){
                    self.addChild(muteOffNode)
                    UserDefaults.standard.set(false, forKey: "mute")
                    muteCount = muteCount + 1
                }
                else{
                    muteOffNode.removeFromParent()
                    UserDefaults.standard.set(true, forKey: "mute")
                    muteCount = muteCount + 1
                }
            }
            
            if newGameNode.contains(pointTouched) {

                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                
                let gameScene = GameScene(size: self.size)
                
                gameScene.scaleMode = .fill
                
                let trueFalse = (UserDefaults.standard.object(forKey: "mute")) as! Bool
                if(trueFalse){
                    let path = Bundle.main.path(forResource: "jump", ofType : "mp3")!
                    let url = URL(fileURLWithPath : path)
                
                    do {
                        self.button = try AVAudioPlayer(contentsOf: url)
                        self.button.play()
                        
                    } catch {
                        print ("There is an issue with this code!")
                    }
                }
                
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
            
        }
        
        
    }

    
}
