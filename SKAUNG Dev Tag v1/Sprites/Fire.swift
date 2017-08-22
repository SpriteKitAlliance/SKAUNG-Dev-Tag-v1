//
//  Fire.swift
//  SKAUNG Dev Tag v1
//
//  Created by DeviL on 2017-07-24.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class Fire: SKSpriteNode {
    
    init() {
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 84, height: 84))
        
        zPosition = 1
        
        setupPhysics()
        
        addEffect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        color = .blue
        
        isUserInteractionEnabled = true
        
        setupPhysics()
        
        addEffect()
    }
    
    func setupPhysics() {
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody!.categoryBitMask = PhysicsCategory.fire
        physicsBody!.contactTestBitMask = PhysicsCategory.player
        physicsBody!.collisionBitMask = 0
        physicsBody!.allowsRotation = false
        physicsBody!.mass = 0
        physicsBody!.isDynamic = false
        physicsBody!.affectedByGravity = false
    }
    
    func addEffect() {
        
        let emitterPath: String = Bundle.main.path(forResource: "Firin", ofType: "sks")!
        
        let node: SKEmitterNode = (NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as? SKEmitterNode)!
        
        self.addChild(node)
    }
}
