//
//  GameScene.swift
//  SKAUNG Dev Tag v1
//
//  Created by Marc Vandehey on 7/24/17.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SquareSprite()
    let fire = Fire()
    
    private var platforms = [Platform]()
    
    private var lastUpdate: TimeInterval = 0
    private var updateTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        player.zPosition = 10
        addChild(player)
        
        player.position.y = -size.height/2+10
        createPhysics()
        createFire()
        
        createPlatforms()
    }
    
    func createFire() {
        fire.zPosition = 1
        fire.position = CGPoint(x: -90, y: 0 - self.size.height / 2)
        addChild(fire)
    }
    
    func createPlatforms() {
        
        if let platformReference = self.childNode(withName: "//platform1") as? SKReferenceNode {
            
            if let platform1 = platformReference.childNode(withName: "//platform") as? Platform {
    
                for i in 0 ..< 4 {
                    if let newPlatform = platform1.copy() as? Platform {
                        print("Added new platform")
//                        patforms contain 7 spikes ...remember to 0 base your count
                        newPlatform.position.y = CGFloat(-140 + i * 140)
                        addChild(newPlatform)
                        newPlatform.setup()
                        newPlatform.activate(spikesToActivate: [0, 6], waitDuration: 2)
                        platforms.append(newPlatform)
                    }

                }
                
                platforms.append(platform1)
            }
        }
    }
    
    func createPhysics() {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.categoryBitMask = PhysicsCategory.boundary
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 0.1
        physicsBody?.friction = 0.0
    }
    
    func checkForCollisions() {
        
        guard player.platform == nil && !player.isJumping else { return }
        guard player.physicsBody != nil else { return }
        
        for platform in platforms {
            
            if player.testBase.intersects(platform.platformTest) && player.physicsBody!.velocity.dy <= 0 {
                player.removeFromParent()
                player.position = self.convert(player.position, to: platform)
                platform.addChild(player)
                
                player.platform = platform
                
                player.stopMoving()
            }
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else {
            
            //Silliness like removing a node from a node tree before physics simulation is done will trigger this error
            fatalError("Physics body without its node detected!")
        }
        
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
            
        //Contact between player and a fire
        case PhysicsCategory.player | PhysicsCategory.fire:
            
            if let _ = (contact.bodyA.categoryBitMask == PhysicsCategory.fire ? nodeA : nodeB) as? SKSpriteNode {
                player.burn()
            }
            
        default:
            //some unknown contact occurred
            break
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        
    }
    
    func touchUp(atPoint pos: CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        var dt = currentTime - lastUpdate
        
        if dt > 1 {
            dt = 0
        }
        
        for child in children where (child as? Updateable) != nil {
            (child as? Updateable)?.update(deltaTime: dt)
        }
        
        if player.parent != self {
            player.update(deltaTime: dt)
        }
        
        checkForCollisions()
        
        lastUpdate = currentTime
    }
}
