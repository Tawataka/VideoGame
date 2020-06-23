//
//  sunGod.swift
//  VideoGame
//
//  Created by Tawa Reyna on 3/11/19.
//  Copyright © 2019 Tawa Reyna. All rights reserved.
//

import UIKit
import SpriteKit

class sunGod: SKScene {
    
    var logo: SKSpriteNode!
    var copyright: SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(displayP3Red: 255/255, green:255/255, blue: 255/255, alpha: 1)
        
        logo = SKSpriteNode(imageNamed: "sungod")
        logo.position = CGPoint(x: self.frame.midX - 10, y: self.frame.midY)
        logo.zPosition = 1
        self.addChild(logo)
        
        copyright = SKLabelNode(text: "Copyright © 2019 SunGod. All rights reserved.")
        copyright.position = CGPoint(x: self.frame.midX + 100, y: self.frame.minY + 50)
        
        copyright.fontSize = 25
        copyright.fontColor = UIColor.black
        copyright.zPosition = 1
        self.addChild(copyright)
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false){ (timer) in
            
            let transition = SKTransition.fade(withDuration: 1.0)
            let homescreen = homeScreen(size: self.size)
            homescreen.scaleMode = .aspectFill
            
            
            self.view?.presentScene(homescreen, transition: transition)
            
            
        }
        
    }
    
}
