//
//  Cannon.swift
//  SKAUNG Dev Tag v1
//
//  Created by Vladimir Jovicevic on 26.7.17..
//  Copyright © 2017. SpriteKit Alliance. All rights reserved.
//

import SpriteKit

/*
 
 Builder Pattern
 
 Not really needed at the moment, but it could be handy if we had multiple types of cannons with even more initialization parameters. So instead of having something like :
 
     let basicCannon = Cannon(
                        bulletSpeed:0.5,
                        rotateTo:270,
                        rotateFrom:100,
                        radius:200,
                        ...etc,
                        ...etc)
 
     we are going to have:
 
     let basicCannon = Cannon(config: BasicCannonConfiguration())
 
     I thought that implementing Builder Pattern here would a smart move.
*/
protocol CannonConfiguration{
    
    var bulletSpeed:CGFloat {get set }
    var rotateFrom:CGFloat {get set }
    var rotateTo:CGFloat {get  set}
    var sightRadius:CGFloat {get  set}
    var rotatingDuration:TimeInterval {get set}
    var fireRate:TimeInterval {get set}
    
}

struct BasicCannonConfiguration:CannonConfiguration {

     var  bulletSpeed: CGFloat = 3
     var  rotateFrom: CGFloat = 0
     var  rotateTo: CGFloat = 360
     var  sightRadius: CGFloat = 200
     var  rotatingDuration: TimeInterval = 2
    var fireRate:TimeInterval = 0.5
}

struct AdvancedCannonConfiguration:CannonConfiguration {
    
     var  bulletSpeed: CGFloat = 4.5
     var  rotateFrom: CGFloat = 0
     var  rotateTo: CGFloat = 360
     var  sightRadius: CGFloat = 400
     var  rotatingDuration: TimeInterval = 1.8
     var fireRate:TimeInterval = 0.3
}

let kCannonRotatingActionKey = "kCannonRotatingActionKey"
let kCannonShootingActionKey = "kCannonShootingActionKey"

class Cannon: SKSpriteNode {
    
    private var barrel: SKSpriteNode!
    private var bullet: SKSpriteNode!
    
    public var configuration:CannonConfiguration!
    
    init(config:CannonConfiguration) {
        
        configuration = config
        let atlas = SKTextureAtlas(named: "Atlas")
        
        let standTexture = atlas.textureNamed("stand")
        bullet = SKSpriteNode(color: .white, size: CGSize(width:18, height:18))
        super.init(texture: standTexture, color: .clear, size: standTexture.size())

        zPosition = 2
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        bullet = SKSpriteNode(color: .white, size: CGSize(width:18, height:18))
        color = SKColor(red:0.98, green:0.31, blue:0.31, alpha:1.0)
        zPosition = 2

        setup()
    }
    
    //in degrees
    func set(range from: CGFloat, to: CGFloat) {
        
        configuration.rotateFrom = from
        configuration.rotateTo = to
        
        let to = configuration.rotateTo.degreesToRadians
        let from = configuration.rotateFrom.degreesToRadians
        let duration = configuration.rotatingDuration
        
        
        let rotateTo = SKAction.rotate(toAngle: to, duration: duration)
        let rotateFrom = SKAction.rotate(toAngle: from, duration: duration)
        
        let sequence = SKAction.sequence([rotateTo, rotateFrom])
        
        let rotate = SKAction.repeatForever(sequence)
        
        run(rotate, withKey: kCannonRotatingActionKey)
    }
    
    func startShooting() {
        
        let fireRate = configuration.fireRate
        let wait = SKAction.wait(forDuration: fireRate)
        let shoot = SKAction.run {
            [weak self] in
            
            self?.shoot(fireEffect: true)
        }
        let sequence = SKAction.sequence([wait, shoot])
        
        run(SKAction.repeatForever(sequence), withKey: kCannonShootingActionKey)
    }
    
    private func addFireEffect(toNode node:SKNode) {
        
        let emitterPath: String = Bundle.main.path(forResource: "Firin", ofType: "sks")!
        
        
        if let emitter = (NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as? SKEmitterNode) {
            emitter.targetNode = node
            node.addChild(emitter)
           
        }
  
    }
    
    private func shoot(fireEffect:Bool = false) {
        
        if let bullet = bullet.copy() as? SKSpriteNode {
            
            if let currentScene = scene  {
                
                currentScene.addChild(bullet)
                
                bullet.position = convert(bullet.position, to: currentScene)
                
                let speed = configuration.bulletSpeed
                
                let dx = speed * cos (zRotation + CGFloat(Double.pi / 2))
                let dy =  speed * sin (zRotation + CGFloat(Double.pi / 2))
                
                bullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
                
                let wait = SKAction.wait(forDuration: 10.0)
                let remove = SKAction.removeFromParent()
                let seq = SKAction.sequence([wait, remove])
                bullet.run(seq)
 
                bullet.zRotation = atan2 ( sin(zRotation + CGFloat(Double.pi / 2)), cos(zRotation + CGFloat(Double.pi / 2) ))
                
                if (fireEffect){
                    
                    addFireEffect(toNode: bullet)
                }
            }
        }
    }

    func setup() {
        
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
