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

  init() {
    super.init(texture: nil, color: .blue, size: CGSize(width: 84, height: 84))

    isUserInteractionEnabled = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    color = .blue

    isUserInteractionEnabled = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if currentTouch == nil {
      currentTouch = touches.first
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
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches where currentTouch == touch {
      currentTouch = nil
    }
  }
}
