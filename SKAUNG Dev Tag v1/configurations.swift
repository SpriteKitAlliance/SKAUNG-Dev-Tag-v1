//
//  configurations.swift
//  SKAUNG Dev Tag v1
//
//  Created by DeviL on 2017-07-24.
//  Copyright © 2017 SpriteKit Alliance. All rights reserved.
//

import Foundation

//Game Physics
struct PhysicsCategory {

    static let boundary: UInt32 = 0x1 << 0
    static let player: UInt32 = 0x1 << 1
    static let fire: UInt32 = 0x1 << 2
    static let platform: UInt32 = 0x1 << 3
    static let spike: UInt32 = 0x1 << 4
}
