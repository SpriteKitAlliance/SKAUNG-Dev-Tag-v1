//
//  SquareSprite.swift
//  SKAUNG Dev Tag v1
//
//  Created by Marc Vandehey on 7/24/17.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import SpriteKit

class SquareSprite: SKSpriteNode {
    
    private var currentTouch: UITouch?

    private var isBurning = false
    
  init() {
    super.init(texture: nil, color: .blue, size: CGSize(width: 84, height: 84))

    isUserInteractionEnabled = true
    colorBlendFactor = 1
    zPosition = 50
    setupPhysics()
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)

    color = .blue

    isUserInteractionEnabled = true
    
    setupPhysics()
  }

    func setupPhysics() {
    
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody!.categoryBitMask = PhysicsCategory.player
        physicsBody!.contactTestBitMask = PhysicsCategory.fire
        physicsBody!.collisionBitMask = PhysicsCategory.boundary
        physicsBody!.allowsRotation = false
        physicsBody!.mass = 0
    }
    
    func burn() {
        
        guard !isBurning else { return }
        
        isBurning = true
        let colorize = SKAction.colorize(with: .black, colorBlendFactor: 1.0, duration: 0.3)
        run(colorize)
        
        let wait = SKAction.wait(forDuration: 2.0)
        self.run(wait) {
            
            let colorize = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.3)
            self.run(colorize)
            self.isBurning = false
        }
    }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if currentTouch == nil {
      currentTouch = touches.first
        
        self.physicsBody!.affectedByGravity = false
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if currentTouch == touch && parent != nil {
        position = (currentTouch?.location(in: parent!))!
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches where currentTouch == touch {
      currentTouch = nil
        self.physicsBody!.affectedByGravity = true
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches where currentTouch == touch {
      currentTouch = nil
        self.physicsBody!.affectedByGravity = true
    }
  }
}
