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
    private var platform1: Platform!
    
  private var lastUpdate: TimeInterval = 0
    private var updateTime: TimeInterval = 0
    
  override func didMove(to view: SKView) {
    player.zPosition = 10
    addChild(player)

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
                self.platform1 = platform1
                
                //patforms contain 7 spikes ...remember to 0 base your count
                platform1.activate(spikesToActivate: [0, 6], waitDuration: 2)
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
        
        if player.testBase.intersects(platform1.platformTest) {

            player.position.y = self.convert(platform1.position, from: platform1).y + platform1.size.height / 2 + player.size.height / 2
            player.stopMoving()
            player.platform = platform1
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
    var movementChecker = currentTime - updateTime
    
    if dt > 1 {
      dt = 0
    }

    for child in children where (child as? Updateable) != nil {
      (child as? Updateable)?.update(deltaTime: dt)
    }

    checkForCollisions()
    
    //check if need to move player with platform but only check every 1/6 of a second not to oveload the process
    
    if movementChecker > 0.1 {
        
        movementChecker = currentTime
        
        if player.platform != nil {
            player.movePlayerWithPlatform()
        }
    }
    
    lastUpdate = currentTime
  }
}
