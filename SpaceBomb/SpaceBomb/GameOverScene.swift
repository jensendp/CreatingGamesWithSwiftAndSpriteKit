//
//  GameOverScene.swift
//  SpaceBomb
//
//  Created by Derek Jensen on 11/30/16.
//  Copyright © 2016 Derek Jensen. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = .white
        
        let label = SKLabelNode(fontNamed: "Cochin")
        label.text = "Game Over"
        label.fontSize = 40
        label.fontColor = .black
        label.position = CGPoint(x: self.size.width/2,y: self.size.height/2)
        self.addChild(label)
        
        let replayButton = SKLabelNode(fontNamed: "Cochin")
        replayButton.text = "Play Again"
        replayButton.fontColor = .black
        replayButton.position = CGPoint(x: self.size.width/2, y: 50)
        replayButton.name = "replay"
        self.addChild(replayButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            if node?.name == "replay" {
                let reveal : SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: self.view!.bounds.size)
                scene.scaleMode = .aspectFill
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

