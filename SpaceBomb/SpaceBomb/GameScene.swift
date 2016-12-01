//
//  GameScene.swift
//  SpaceBomb
//
//  Created by Derek Jensen on 11/28/16.
//  Copyright © 2016 Derek Jensen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ship = SKSpriteNode()
    var shipMoveUp = SKAction()
    var shipMoveDown = SKAction()
    
    var lastBombAdded: TimeInterval = 0
    
    let backgroundVelocity: CGFloat = 3.0
    let bombVelocity: CGFloat = 5.0
    
    let shipCategory = 0x1 << 0
    let bombCategory = 0x1 << 1
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        self.addBackground()
        self.addShip()
        self.addBomb()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func addShip() {
        ship = SKSpriteNode(imageNamed: "Spaceship")
        ship.setScale(0.25)
        ship.zRotation = CGFloat(-M_PI/2)
        
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.categoryBitMask = UInt32(shipCategory)
        ship.physicsBody?.contactTestBitMask = UInt32(bombCategory)
        ship.physicsBody?.collisionBitMask = 0
        ship.name = "ship"
        ship.position = CGPoint(x: 120, y: 160)
        
        shipMoveUp = SKAction.moveBy(x: 0, y: 30, duration: 0.2)
        shipMoveDown = SKAction.moveBy(x: 0, y: -30, duration: 0.2)
        
        self.addChild(ship)
    }
    
    func addBackground() {
        for index in 0..<2 {
            let bg = SKSpriteNode(imageNamed: "back")
            bg.position = CGPoint(x: index * Int(bg.size.width), y: 0)
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.name = "background"
            
            self.addChild(bg)
        }
    }
    
    func addBomb() {
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.setScale(0.15)
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.isDynamic = true
        bomb.name = "bomb"
        bomb.physicsBody?.categoryBitMask = UInt32(bombCategory)
        bomb.physicsBody?.contactTestBitMask = UInt32(shipCategory)
        bomb.physicsBody?.collisionBitMask = 0
        bomb.physicsBody?.usesPreciseCollisionDetection = true
        
        let random: CGFloat = CGFloat(arc4random_uniform(300))
        bomb.position = CGPoint(x: self.frame.size.width + 20, y: random)
        self.addChild(bomb)
    }
    
    func moveBackground() {
        self.enumerateChildNodes(withName: "background", using: {(node, stop) -> Void in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x - self.backgroundVelocity, y: bg.position.y)
                
                if bg.position.x <= -bg.size.width {
                    bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                }
            }
        })
    }
    
    func moveBomb() {
        self.enumerateChildNodes(withName: "bomb", using: {(node, stop) -> Void in
            if let bomb = node as? SKSpriteNode {
                bomb.position = CGPoint(x: bomb.position.x - self.bombVelocity, y: bomb.position.y)
                
                if bomb.position.x < 0 {
                    bomb.removeFromParent()
                }
            }
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & UInt32(shipCategory)) != 0 && (secondBody.categoryBitMask & UInt32(bombCategory)) != 0 {
            ship.removeFromParent()
            let gameOverScene = GameOverScene(size: self.size)
            self.view?.presentScene(gameOverScene, transition: .doorway(withDuration: 1))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.moveBackground()
        self.moveBomb()
        
        if currentTime - self.lastBombAdded > 1 {
            self.lastBombAdded = currentTime + 1
            self.addBomb()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if location.y > ship.position.y {
                if ship.position.y < 300 {
                    ship.run(shipMoveUp)
                }
            }else {
                if ship.position.y > 50 {
                    ship.run(shipMoveDown)
                }
            }
        }
    }
    
}
