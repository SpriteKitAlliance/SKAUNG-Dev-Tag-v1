//
//  Extensions.swift
//  SKAUNG Dev Tag v1
//
//  Created by Vladimir Jovicevic on 26.7.17..
//  Copyright © 2017. SpriteKit Alliance. All rights reserved.
//

import Foundation

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
