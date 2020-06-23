//
//  GameViewController.swift
//  VideoGame
//
//  Created by Tawa Reyna on 2/18/19.
//  Copyright © 2019 Tawa Reyna. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds


class GameViewController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // In this case, we instantiate the banner with desired ad size.
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "sunGod") {
                // Set the scale mode to scale to fit the window
                if (UIDevice().userInterfaceIdiom == .phone) {
                    switch UIScreen.main.nativeBounds.height {
            
                    case 1136, 1334, 1920, 2208:
                        scene.size = CGSize(width: 750, height: 1334)
                        
                        UserDefaults.standard.set(true, forKey: "score")
                        
                    case 2436, 2688, 1792:
                        scene.size = CGSize(width: 750, height: 1495)
                        
                        UserDefaults.standard.set(false, forKey: "score")
                        
                    default:
                        scene.size = CGSize(width: 750, height: 1334)
                        
                        UserDefaults.standard.set(true, forKey: "score")
                    }
                }
        
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
            }
        
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            
        }
        
        
       
    }
    
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    
}
