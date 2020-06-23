//
//  GameScene.swift
//  VideoGame
//
//  Created by Tawa Reyna on 2/18/19.
//  Copyright © 2019 Tawa Reyna. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation
import UIKit
import GoogleMobileAds

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backround: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var tutor: SKSpriteNode!
    
    var leftButtonNode: SKSpriteNode!
    var rightButtonNode: SKSpriteNode!
    var shootButtonNode: SKSpriteNode!
    var scorePos = true
    var FScore: Int = 0
    
    var score:Int = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var bubbleCount = 1
    

    
    var loose = AVAudioPlayer()
    var pop = AVAudioPlayer()
    var shoot = AVAudioPlayer()
    
    var gameTimer: Timer!
    
    var possibleBadGuys = ["BadGuys1", "BadGuys2", "BadGuys3"]
    
    var possibleBubble = ["bobble_1", "bobble_2", "bobble_3", "bobble_4"]
    
    
    let BadGuysCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var livesArray:[SKSpriteNode]!
    
    override func didMove(to view: SKView) {
         self.backgroundColor = SKColor(displayP3Red: 228/255, green: 205/255, blue: 155/255, alpha: 1)
        
        addLives()
        
        backround = SKEmitterNode(fileNamed: "backround")
        backround.position = CGPoint(x: 350, y: 1472)
        backround.advanceSimulationTime(20)
        self.addChild(backround)
        backround.zPosition = -2
        
        
        player = SKSpriteNode(imageNamed: "character_1")
        player.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 300)
        player.zPosition = 2
        self.addChild(player)
        
        tutor = SKSpriteNode(imageNamed: "tutor")
        tutor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 700)
        tutor.zPosition = 5
        self.addChild(tutor)
        
        if( UserDefaults.standard.object(forKey: "big") != nil){
            FScore = UserDefaults.standard.object(forKey: "big") as! Int
            
        }
        if(FScore > 10){
            tutor.removeFromParent()
        }
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        
        scorePos = UserDefaults.standard.object(forKey: "score") as! Bool
        if (scorePos == false){
        scoreLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.maxY - 120)
        }
        else{
            scoreLabel.position = CGPoint(x: self.frame.minX + 150, y: self.frame.maxY - 70)
        }
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor.black
        scoreLabel.zPosition = 2
        score = 0
        
        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: (1.5), target: self, selector:  #selector(addBadGuys), userInfo: nil, repeats: true)
        
        /*
         motionManager.accelerometerUpdateInterval = 0.2
         motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data:CMAccelerometerData?, error:Error?) in
         if let accelerometerData = data {
         let acceleration = accelerometerData.acceleration
         self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
         }
         }
        */
        
        leftButtonNode = SKSpriteNode(imageNamed: "left_button")
        leftButtonNode.position = CGPoint(x: self.frame.midX - 230, y: self.frame.minY + 120)
        leftButtonNode.zPosition = 2
        self.addChild(leftButtonNode)
        
        rightButtonNode = SKSpriteNode(imageNamed: "right_button")
        rightButtonNode.position = CGPoint(x: self.frame.midX + 35, y: self.frame.minY + 120)
        rightButtonNode.zPosition = 2
        self.addChild(rightButtonNode)
        
        shootButtonNode = SKSpriteNode(imageNamed: "shoot_button")
        shootButtonNode.position = CGPoint(x: self.frame.midX + 270, y: self.frame.minY + 120)
        shootButtonNode.zPosition = 2
        self.addChild(shootButtonNode)
 
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointTouched = touch.location(in: self)
            
            if self.contains(pointTouched){
                tutor.removeFromParent()
                
            }
            
            if leftButtonNode.contains(pointTouched) {
                movePlayer(moveBy: -20, forTheKey: "left")
            }
            
            if rightButtonNode.contains(pointTouched) {
                movePlayer(moveBy: 20, forTheKey: "right")
            }
            
            if shootButtonNode.contains(pointTouched) {
               firebubble()
            }
            
        }
       
    }
    
    func movePlayer (moveBy: CGFloat, forTheKey: String) {
        let moveAction = SKAction.moveBy(x: moveBy, y: 0, duration: 0.03)
        let repeatForEver = SKAction.repeatForever(moveAction)
        let seq = SKAction.sequence([moveAction, repeatForEver])
        
        player.run(seq, withKey: forTheKey)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.removeAction(forKey: "left")
        player.removeAction(forKey: "right")
        
    }
    
 
    func addLives(){
        
        livesArray = [SKSpriteNode]()
        
            let liveNode = SKSpriteNode()
            self.addChild(liveNode)
            livesArray.append(liveNode)
        
    }
    
    @objc func addBadGuys(){
        possibleBadGuys = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleBadGuys) as! [String]
        
        let BadGuys = SKSpriteNode(imageNamed: possibleBadGuys[0])
        
        let randomBadGuyPosition = GKRandomDistribution(lowestValue: 40, highestValue: 680)
        let position = CGFloat(randomBadGuyPosition.nextInt())
        
        BadGuys.position = CGPoint(x: position, y: self.frame.size.height + BadGuys.size.height)
        
        BadGuys.physicsBody = SKPhysicsBody(rectangleOf: BadGuys.size)
        BadGuys.physicsBody?.isDynamic = true
        
        BadGuys.physicsBody?.categoryBitMask = BadGuysCategory
        BadGuys.physicsBody?.contactTestBitMask = photonTorpedoCategory
        BadGuys.physicsBody?.collisionBitMask = 0
        
        self.addChild(BadGuys)
        
        BadGuys.zPosition = -1
    
        var animationDuration: TimeInterval = 4.5
        
        
        if(score > 30){
            animationDuration = 4.0
        }
        if(score > 60){
            animationDuration = 3.7
           
        }
        if(score > 90){
            animationDuration = 3.4
        }
        if(score > 150){
            animationDuration = 3.2
     
        }
        if(score > 250){
            animationDuration = 2.9
        }
        if(score > 350){
            animationDuration = 2.8
            
        }
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position , y: -50), duration: animationDuration))
        
        
        actionArray.append(SKAction.run {
        
                let liveNode = self.livesArray.first
                liveNode!.removeFromParent()
                self.livesArray.removeFirst()
            
        
                if (self.livesArray.count == 0) {
                    

                    //gameOver
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                        
                    let gameOver = EndScreen(size: self.size)
                    gameOver.scaleMode = .aspectFill
                    gameOver.score = self.score
                        
                    let trueFalse = (UserDefaults.standard.object(forKey: "mute")) as! Bool
                    if(trueFalse){
                        let path = Bundle.main.path(forResource: "loose", ofType : "mp3")!
                        let url = URL(fileURLWithPath : path)
                            
                        do {
                            self.loose = try AVAudioPlayer(contentsOf: url)
                            self.loose.play()
                                
                        } catch {
                            print ("There is an issue with this code!")
                        }
                    }
                
                    self.view?.presentScene(gameOver, transition: transition)
                        
                }
            
            var livecount = UserDefaults.standard.object(forKey: "liveCount") as! Int
            livecount = livecount + 1
            UserDefaults.standard.set(livecount, forKey: "liveCount")
             print(livecount)
            
            
          })
        
        
        actionArray.append(SKAction.removeFromParent())
        
        BadGuys.run(SKAction.sequence(actionArray))
        
        
        
    }
 
    func firebubble(){
        let trueFalse = (UserDefaults.standard.object(forKey: "mute")) as! Bool
        if(trueFalse){
            let path = Bundle.main.path(forResource: "shoot", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            
            do {
                self.shoot = try AVAudioPlayer(contentsOf: url)
                self.shoot.play()
                
            } catch {
                print ("There is an issue with this code!")
            }
        }
        possibleBubble = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleBubble) as! [String]
        
        let bubbleNode = SKSpriteNode(imageNamed: possibleBubble[0])
        
        
        if(bubbleCount % 2 == 0){
            bubbleNode.position = CGPoint(x: player.position.x + 50, y: player.position.y )
            
            bubbleCount = bubbleCount + 1
        }
        else{
            bubbleNode.position = CGPoint(x: player.position.x - 50, y: player.position.y )
            
            bubbleCount = bubbleCount + 1
        }
        bubbleNode.position.y += 5
        
        bubbleNode.physicsBody = SKPhysicsBody(circleOfRadius: bubbleNode.size.width / 2)
        bubbleNode.physicsBody?.isDynamic = true
        
        bubbleNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        bubbleNode.physicsBody?.contactTestBitMask = BadGuysCategory
        bubbleNode.physicsBody?.collisionBitMask = 0
        bubbleNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bubbleNode)
        
        let animationDuration: TimeInterval = 1.0
        
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x , y: self.frame.size.height + 50), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        bubbleNode.run(SKAction.sequence(actionArray))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & BadGuysCategory) != 0 {
            bubbleDidCollideWithBadGuys(bubbleNode: firstBody.node as! SKSpriteNode, BadGuysNode: secondBody.node as! SKSpriteNode)
        }
        
        
    }
    
    func bubbleDidCollideWithBadGuys (bubbleNode:SKSpriteNode, BadGuysNode:SKSpriteNode){
        
        
        let explosion = SKEmitterNode(fileNamed: "MyParticle")!
        explosion.position = BadGuysNode.position
        
        self.addChild(explosion)
        
        bubbleNode.removeFromParent()
        BadGuysNode.removeFromParent()
        
        let trueFalse = (UserDefaults.standard.object(forKey: "mute")) as! Bool
        if(trueFalse){
            let path = Bundle.main.path(forResource: "pop", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            
            do {
                self.pop = try AVAudioPlayer(contentsOf: url)
                self.pop.play()
                
            } catch {
                print ("There is an issue with this code!")
            }
        }
        self.run(SKAction.wait(forDuration: 2)){
            
            explosion.removeFromParent()
            
        }
        
        score += 1
        
        if(score == 10){
            if (scorePos == false){
                scoreLabel.position = CGPoint(x: self.frame.minX + 170, y: self.frame.maxY - 120)
            }
            else{
                scoreLabel.position = CGPoint(x: self.frame.minX + 170, y: self.frame.maxY - 70)
            }
        }
        if(score == 100){
            if (scorePos == false){
                scoreLabel.position = CGPoint(x: self.frame.minX + 190, y: self.frame.maxY - 120)
            }
            else{
                scoreLabel.position = CGPoint(x: self.frame.minX + 190, y: self.frame.maxY - 70)
            }
        }
        if(score == 1000){
            if (scorePos == false){
                scoreLabel.position = CGPoint(x: self.frame.minX + 210, y: self.frame.maxY - 120)
            }
            else{
                scoreLabel.position = CGPoint(x: self.frame.minX + 210, y: self.frame.maxY - 70)
            }
        }
        
        
        if(score == 50){
            
            gameTimer = Timer.scheduledTimer(timeInterval: (1.4), target: self, selector:  #selector(addBadGuys), userInfo: nil, repeats: true)
            
        }
      
        else if(score == 250){
            
            gameTimer = Timer.scheduledTimer(timeInterval: (1.9), target: self, selector:  #selector(addBadGuys), userInfo: nil, repeats: true)
            
        }
        
        else if(score == 500){
            
            gameTimer = Timer.scheduledTimer(timeInterval: (2.1), target: self, selector:  #selector(addBadGuys), userInfo: nil, repeats: true)
            
        }
        
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        
        if player.position.x < 0{
            player.position = CGPoint(x: 700, y: player.position.y)
        }else if(player.position.x > 700){
            player.position = CGPoint(x: 0, y: player.position.y)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
 
}
 
