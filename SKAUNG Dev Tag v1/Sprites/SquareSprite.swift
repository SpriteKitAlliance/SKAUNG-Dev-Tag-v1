//
//  SquareSprite.swift
//  SKAUNG Dev Tag v1
//
//  Created by Marc Vandehey on 7/24/17.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import SpriteKit

class SquareSprite: SKSpriteNode, Updateable {

  private var currentTouch: UITouch?
  private var isBurning = false
  var isJumping = false
  private var currentHoldTime: TimeInterval = 0

  private let powerPerTime: TimeInterval = 0.5
  private var powerLevel = 0
  private let maxPowerLevel = 4

  private var textures = [SKTexture]()
  var testBase: SKSpriteNode!
    var platform: Platform?
    
  init() {
    let texture = SKTexture(imageNamed: "ska-0")

    super.init(texture: texture, color: SKColor(red:0.98, green:0.31, blue:0.31, alpha:1.0), size: texture.size())

    isUserInteractionEnabled = true
    colorBlendFactor = 1
    zPosition = 50
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)

    color = SKColor(red:0.98, green:0.31, blue:0.31, alpha:1.0)

    isUserInteractionEnabled = true

    setup()
  }

  private func setup() {
    
    for index in 0..<4 {
      let texture = SKTexture(imageNamed: "ska-\(index)")

      textures.append(texture)
    }

    testBase = SKSpriteNode(color: .clear, size: CGSize(width: self.size.width, height: 10))
    testBase.position = CGPoint(x: 0, y: 0 - self.size.height / 2 + 5)
    self.addChild(testBase)
        
    setupPhysics()
  }

  private func setupPhysics() {
    self.physicsBody = SKPhysicsBody(rectangleOf: texture!.size())
    physicsBody!.categoryBitMask = PhysicsCategory.player
    physicsBody!.contactTestBitMask = PhysicsCategory.fire
    physicsBody!.collisionBitMask = PhysicsCategory.boundary
    physicsBody!.allowsRotation = false
    physicsBody!.restitution = 0.2
    physicsBody!.friction = 0.1
    physicsBody!.angularDamping = 0
    physicsBody!.linearDamping = 0.0
    physicsBody!.affectedByGravity = true
    physicsBody!.mass = 10
    physicsBody!.density = 5
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
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if currentTouch == touch && parent != nil, !frame.contains((currentTouch?.location(in: self))!) {
        //Dragged out
        jump()

        currentTouch = nil
      }
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches where currentTouch == touch {
      currentTouch = nil
      jump()
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches where currentTouch == touch {
      currentTouch = nil
      jump()
    }
  }

  private func jump() {
    
    platform = nil
    isJumping = true
    
    self.run(SKAction.wait(forDuration: 0.1)) {
        self.isJumping = false
    }
    
    switch powerLevel {
    case 0:
      print("0 triggered")
      physicsBody?.applyImpulse(CGVector(dx: 0, dy: 800))

    case 1:
      print("1 triggered")
      physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2000))

    case 2:
      print("2 triggered")
      physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3000))

    case 3:
      print("3 triggered")
      physicsBody?.applyImpulse(CGVector(dx: 0, dy: 4000))

    default:
      //Jumping??
      physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))

      print("default triggered")
    }
    
    physicsBody?.affectedByGravity = true
    
    powerLevel = 0
    currentHoldTime = 0
  }

  private func updateSprite() {
    if powerLevel >= 0 && powerLevel < 4 {
      texture = textures[powerLevel]
    }

    if powerLevel == 0 && physicsBody!.velocity.dy < CGFloat(10.0) {
      texture = textures[0]
    }
  }

    func stopMoving() {
        
        physicsBody?.affectedByGravity = false
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
    }
    
  func update(deltaTime: TimeInterval) {
    if currentTouch != nil {
      currentHoldTime += deltaTime
    }

    let power = Int(floor(currentHoldTime / powerPerTime))

    if power < 4 {
      powerLevel = power
    }

    updateSprite()
  }
    
    func movePlayerWithPlatform() {
        
        if platform != nil {
            
            let posX = self.scene?.convert((platform?.position)!, from: platform!).x
            position.x = posX!
        }
    }
}
