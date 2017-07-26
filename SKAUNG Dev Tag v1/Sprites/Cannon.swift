//
//  Cannon.swift
//  SKAUNG Dev Tag v1
//
//  Created by Vladimir Jovicevic on 26.7.17..
//  Copyright © 2017. SpriteKit Alliance. All rights reserved.
//

import SpriteKit



class Cannon:SKSpriteNode {
    
    private var barrel:SKSpriteNode!
    private let bullet = SKSpriteNode(color: .white, size: CGSize(width:7, height:7))
    
    init() {
        let atlas = SKTextureAtlas(named: "Atlas")
        
        let standTexture = atlas.textureNamed("stand")
        
        
        
        super.init(texture: standTexture, color: .clear, size: standTexture.size())
        
        //isUserInteractionEnabled = true
        
        zPosition = 2
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        color = SKColor(red:0.98, green:0.31, blue:0.31, alpha:1.0)
        
        isUserInteractionEnabled = true
        
        setup()
    }
    //in degrees
    func set(range from:CGFloat, to:CGFloat){
        
        
        
        let rotateTo = SKAction.rotate(toAngle: to.degreesToRadians, duration: 1)
        let rotateFrom = SKAction.rotate(toAngle: from.degreesToRadians, duration: 1)
        
        let sequence = SKAction.sequence([rotateTo,rotateFrom])
        
        let rotate = SKAction.repeatForever(sequence)
        
        run(rotate, withKey: "rotating")
    }
    
    func startShooting(){
        let wait = SKAction.wait(forDuration: 0.2)
        let shoot = SKAction.run {
            [weak self] in
            
            self?.shoot()
        }
        let sequence = SKAction.sequence([wait, shoot])
        
        run(SKAction.repeatForever(sequence), withKey: "shooting")
    }
    
    private func shoot(){
        
        if let bullet = bullet.copy() as? SKSpriteNode {
            
            scene?.addChild(bullet)
            
            bullet.position = convert(bullet.position, to: scene!)
            
            let speed:CGFloat = 0.5

            let dx = speed * cos (zRotation + CGFloat(M_PI_2))
            let dy =  speed * sin (zRotation + CGFloat(M_PI_2))
            
            bullet.physicsBody?.applyImpulse(CGVector(dx:dx, dy:dy))
            
        }
    }
   
    
    func setup(){
        
        let atlas = SKTextureAtlas(named: "Atlas")
        let barrelTexture = atlas.textureNamed("barrel")
        barrel = SKSpriteNode(texture: barrelTexture)
        barrel.zPosition = 1
        addChild(barrel)
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = 0
        bullet.physicsBody?.contactTestBitMask = 0
        bullet.physicsBody?.collisionBitMask = 0
        
    }

    
}
