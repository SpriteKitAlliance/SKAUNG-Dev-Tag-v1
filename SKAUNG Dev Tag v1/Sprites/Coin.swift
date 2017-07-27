//
//  Coin.swift
//  SKAUNG Dev Tag v1
//
//  Created by DeviL on 2017-07-26.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    var isGotten = false
    
    init() {
        
        super.init(texture: nil, color: .magenta, size: CGSize.zero)
        
        setup()
    
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
    
        self.texture = SKTexture(image: #imageLiteral(resourceName: "coin1"))
        self.size = texture!.size()
        
        let wait = SKAction.wait(forDuration: 20)
        let remove = SKAction.removeFromParent()
        let removeSequence = SKAction.sequence([wait, remove])
        let group = SKAction.group([SKAction(named: "CoinAnimation")!, removeSequence])
        self.run(group, withKey: "spinning")
    }
    
    private func setupPhysics() {
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.texture!.size().width / 2)
        physicsBody!.categoryBitMask = PhysicsCategory.coin
        physicsBody!.contactTestBitMask = PhysicsCategory.player
        physicsBody!.collisionBitMask = 0
        physicsBody!.allowsRotation = false
        physicsBody!.affectedByGravity = false
        physicsBody!.isDynamic = false
    }
    
    func explode() {
        
        let emitterPath: String = Bundle.main.path(forResource: "Explodin", ofType: "sks")!
        
        let node: SKEmitterNode = (NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as? SKEmitterNode)!
        self.addChild(node)
        
        self.run(SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false))
        let spin = SKAction.rotate(byAngle: 2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0, duration: 0.5)
        let remove = SKAction.removeFromParent()
        let explodeSeq = SKAction.sequence([spin, scaleDown, remove])
        
        self.run(explodeSeq)
    }
}
