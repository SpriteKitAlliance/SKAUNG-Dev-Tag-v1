//
//  GameScene.swift
//  SKAUNG Dev Tag v1
//
//  Created by Marc Vandehey on 7/24/17.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  let sprite = SquareSprite()
  override func didMove(to view: SKView) {
    sprite.zPosition = 10
    addChild(sprite)
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
    // Called before each frame is rendered
  }
}
