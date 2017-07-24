//
//  Platform.swift
//  SKAUNG Dev Tag v1
//
//  Created by DeviL on 2017-07-24.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class Platform: SKSpriteNode {
    
    private var spikes = [SKSpriteNode]()
    private var movingSpikes = [Int]()
    private var waitDuration: Double = 0
    var platformTest: SKSpriteNode!
    
    init() {
        
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
    
        if let spike1 = self.childNode(withName: "spike1") as? SKSpriteNode {
            spike1.isHidden = true
            spikes.append(spike1)
        }
        
        if let spike2 = self.childNode(withName: "spike2") as? SKSpriteNode {
            spike2.isHidden = true
            spikes.append(spike2)
        }
        
        if let spike3 = self.childNode(withName: "spike3") as? SKSpriteNode {
            spike3.isHidden = true
            spikes.append(spike3)
        }
        
        if let spike4 = self.childNode(withName: "spike4") as? SKSpriteNode {
            spike4.isHidden = true
            spikes.append(spike4)
        }
        
        if let spike5 = self.childNode(withName: "spike5") as? SKSpriteNode {
            spike5.isHidden = true
            spikes.append(spike5)
        }
        
        if let spike6 = self.childNode(withName: "spike6") as? SKSpriteNode {
            spike6.isHidden = true
            spikes.append(spike6)
        }
        
        if let spike7 = self.childNode(withName: "spike7") as? SKSpriteNode {
            spike7.isHidden = true
            spikes.append(spike7)
        }
        
        if let platformTest = self.childNode(withName: "platformTest") as? SKSpriteNode {
            self.platformTest = platformTest
        }
    }
    
    func activate(spikesToActivate: [Int], waitDuration: Double) {
        
        movingSpikes = spikesToActivate
        self.waitDuration = waitDuration
        
        for number in movingSpikes {
            
            let spike = spikes[number]
            spike.isHidden = false
            spike.run(movingAction())
        }
        
        for (index, spike) in spikes.enumerated() {
            
            if spikesToActivate.contains(index) {
                
                spike.isHidden = false
                spike.run(movingAction())
            }
            else {
                spike.physicsBody = nil
            }
        }

    }
    
    func movingAction() -> SKAction {
        
        let moveUp = SKAction.moveBy(x: 0, y: 16, duration: 1)
        let moveDown = SKAction.moveBy(x:0, y: -16, duration: 1)
        let wait = SKAction.wait(forDuration: waitDuration)
        let seq = SKAction.sequence([wait, moveUp, wait, moveDown])
        let repeater = SKAction.repeatForever(seq)
        
        return repeater
    }
}
